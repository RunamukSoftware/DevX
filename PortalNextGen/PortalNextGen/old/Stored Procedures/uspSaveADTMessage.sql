CREATE PROCEDURE [old].[uspSaveADTMessage]
    (
        @MessageNumber              INT,
        /*Configuration settings*/
        @DynAddOrgs                 BIT,
        @DynAddSendingSys           BIT,
        @PatientTypeAccountNumber   BIT,
        @UniqueVisitNumber          BIT,
        @DynamicallyAddNursingUnits BIT,
        @DynamicallyAddUSID         BIT,
        /*Configuration settings*/

        /*Msh(organization Information)*/
        @SendingSystem              NVARCHAR(180),
        @SendingFacility            NVARCHAR(180),
        /*Msh(organization Information)*/

        /*Patient Demographic information*/
        @PatientMedicalRecordNumber NVARCHAR(20),
        @PatientAccount             NVARCHAR(20) = NULL,
        @PatientGivenName           NVARCHAR(48) = NULL,
        @PatientFamilyName          NVARCHAR(48) = NULL,
        @PatientMiddleName          NVARCHAR(48) = NULL,
        @PatientDateOfBirth         DATE         = NULL,
        @PatientGender              NCHAR(1)     = NULL,
        /*Patient Demographic information*/

        /*Patient Visit Information*/
        @PatientClass               NCHAR(1),
        @PatientPointOfCare         NVARCHAR(80),
        @PatientVisitNumber         NVARCHAR(20),
        @PatientRoom                NVARCHAR(80) = NULL,
        @PatientBed                 NVARCHAR(80) = NULL,
        @VIPIndicator               BIT,
        @AdmitDateTime              DATETIME2(7) = NULL,
        @DischargeDateTime          DATETIME2(7) = NULL
    /*Patient Visit Information*/
    )
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            --Getting the Message Control ID from the message No
            DECLARE
                @MessageControlID   NVARCHAR(10),
                @FacilityID         INT,
                @SendingSystemID    INT,
                @UnitID             INT,
                @UnitCode           NVARCHAR(20),
                @PatientClassCodeID INT;

            SET @MessageControlID =
                (
                    SELECT
                        [him].[MessageControlID]
                    FROM
                        [HL7].[InboundMessage] AS [him]
                    WHERE
                        [him].[MessageNumber] = @MessageNumber
                );

            --Checking the facility and sending system existing in the current system, if not returing the error message.
            EXEC [HL7].[uspInsertInboundFacility]
                @SendingFacility,
                @DynAddOrgs,
                @FacilityID OUT;

            IF (@FacilityID IS NOT NULL)
                BEGIN
                    EXEC [HL7].[uspInsertInboundSendingSystem]
                        @SendingSystem,
                        @DynAddSendingSys,
                        @FacilityID,
                        @SendingSystemID OUT;
                END;

            IF (
                   @FacilityID IS NULL
                   OR @SendingSystemID IS NULL
               )
                BEGIN
                    INSERT INTO [HL7].[PatientLink]
                        (
                            [MessageNumber],
                            [PatientMedicalRecordNumber],
                            [PatientVisitNumber],
                            [PatientID]
                        )
                    VALUES
                        (
                            @MessageNumber, @PatientMedicalRecordNumber, @PatientVisitNumber, NULL
                        );

                    RAISERROR(
                                 N'Sending Application "%s" or Sending Facility "%s" is not present at the database for MessageControlID="%s".',
                                 16, 1, @SendingSystem, @SendingFacility, @MessageControlID
                             );
                    RETURN;
                END;

            -- Inserts the new unit if Dynamically Add nursing units are set to true
            SET @UnitID =
                (
                    SELECT
                        [io].[OrganizationID]
                    FROM
                        [Intesys].[Organization] AS [io]
                    WHERE
                        [io].[CategoryCode] = 'D'
                        AND [io].[OrganizationCode] = @PatientPointOfCare
                        AND [io].[ParentOrganizationID] = @FacilityID
                );

            IF (@UnitID IS NULL)
                BEGIN
                    IF (@DynamicallyAddNursingUnits = 1)
                        BEGIN
                            SET @UnitID = 0; --NEWID();
                            EXEC [old].[uspInsertOrganizationInformation]
                                @OrganizationID = @UnitID,
                                @CategoryCode = 'D',
                                @AutoCollectInterval = 1,
                                @ParentOrganizationID = @FacilityID,
                                @OrganizationCode = @PatientPointOfCare,
                                @OrganizationName = @PatientPointOfCare;
                        END;
                    ELSE
                        BEGIN
                            INSERT INTO [HL7].[PatientLink]
                                (
                                    [MessageNumber],
                                    [PatientMedicalRecordNumber],
                                    [PatientVisitNumber],
                                    [PatientID]
                                )
                            VALUES
                                (
                                    @MessageNumber, @PatientMedicalRecordNumber, @PatientVisitNumber, NULL
                                );

                            RAISERROR(
                                         N'Facility for "%s" unit is not present at the database or DynAddNursingUnits configuration is set to false for MessageControlID="%s".',
                                         16, 1, @PatientPointOfCare, @MessageControlID
                                     );
                            RETURN;
                        END;
                END;

            -- Check the Unit is Licensed
            EXEC [old].[uspGetUnitLicense]
                'inHL7',
                'D',
                @UnitID,
                @UnitCode OUT;

            IF (@UnitCode IS NULL)
                BEGIN
                    INSERT INTO [HL7].[PatientLink]
                        (
                            [MessageNumber],
                            [PatientMedicalRecordNumber],
                            [PatientVisitNumber],
                            [PatientID]
                        )
                    VALUES
                        (
                            @MessageNumber, @PatientMedicalRecordNumber, @PatientVisitNumber, NULL
                        );
                    RAISERROR(
                                 N'Unit "%s" is not Licensed for MessageControlID="%s".', 16, 1, @PatientPointOfCare,
                                 @MessageControlID
                             );
                    RETURN;
                END;
        END TRY
        BEGIN CATCH
            UPDATE
                [HL7].[InboundMessage]
            SET
                [MessageStatus] = 'E'
            WHERE
                [MessageNumber] = @MessageNumber;
            DECLARE @ErrorMessage NVARCHAR(4000);
            DECLARE @ErrorSeverity INT;
            DECLARE @ErrorState INT;
            SELECT
                @ErrorMessage  = ERROR_MESSAGE(),
                @ErrorSeverity = ERROR_SEVERITY(),
                @ErrorState    = ERROR_STATE();

            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
            RETURN;
        END CATCH;

        BEGIN TRY
            BEGIN TRAN;

            -- Get patient GenderCode from the Int_misc_code
            DECLARE @PatientGenderCodeID INT;
            IF (@PatientGender IS NOT NULL)
                BEGIN
                    EXEC [old].[uspGetCodeByCategoryCode]
                        @CategoryCode = 'SEX',
                        @MethodCode = N'HL7',
                        @Code = @PatientGender,
                        @OrganizationID = @FacilityID,
                        @SendingSystemID = @SendingSystemID,
                        @CodeID = @PatientGenderCodeID OUT;
                    IF (
                           @PatientGenderCodeID IS NULL
                           AND @DynamicallyAddUSID = 1
                       )
                        BEGIN
                            SET @PatientGenderCodeID =
                                (
                                    SELECT
                                        CAST(RAND() * 10000 AS INT) AS [RandomNumber]
                                );
                            WHILE (
                                      (
                                          SELECT
                                              [imc].[CodeID]
                                          FROM
                                              [Intesys].[MiscellaneousCode] AS [imc]
                                          WHERE
                                              [imc].[CodeID] = @PatientGenderCodeID
                                      ) IS NOT NULL
                                  )
                                BEGIN
                                    SET @PatientGenderCodeID = @PatientGenderCodeID + 1;
                                END;

                            EXEC [old].[uspInsertMiscCodeDetails]
                                @PatientGenderCodeID,
                                @FacilityID,
                                @SendingSystemID,
                                'SEX',
                                N'HL7',
                                @PatientGender;
                        END;
                END;

            -- Get patient Class from the Int_misc_code
            EXEC [old].[uspGetCodeByCategoryCode]
                @CategoryCode = 'PCLS',
                @MethodCode = 'HL7',
                @Code = @PatientClass,
                @OrganizationID = @FacilityID,
                @SendingSystemID = @SendingSystemID,
                @CodeID = @PatientClassCodeID OUT;
            IF (
                   @PatientClassCodeID IS NULL
                   AND @DynamicallyAddUSID = 1
               )
                BEGIN
                    SET @PatientClassCodeID =
                        (
                            SELECT
                                CAST(RAND() * 10000 AS INT) AS [RandomNumber]
                        );
                    WHILE (
                              (
                                  SELECT
                                      [imc].[CodeID]
                                  FROM
                                      [Intesys].[MiscellaneousCode] AS [imc]
                                  WHERE
                                      [imc].[CodeID] = @PatientClassCodeID
                              ) IS NOT NULL
                          )
                        BEGIN
                            SET @PatientClassCodeID = @PatientClassCodeID + 1;
                        END;

                    EXEC [old].[uspInsertMiscCodeDetails]
                        @PatientClassCodeID,
                        @FacilityID,
                        @SendingSystemID,
                        'PCLS',
                        'HL7',
                        @PatientClass;
                END;

            -- Process Patient Demographic Information
            DECLARE
                @PatientID INT,
                @AccountID INT;
            EXEC [HL7].[uspSavePatientDemographicInformation]
                @PatientTypeAccountNumber,
                @PatientMedicalRecordNumber,
                @PatientAccount,
                @FacilityID,
                @PatientGivenName,
                @PatientFamilyName,
                @PatientMiddleName,
                @PatientDateOfBirth,
                @PatientGenderCodeID,
                @PatientID OUT,
                @AccountID OUT;
            --IF (@PatientMedicalRecordNumber IS NOT NULL)
            --BEGIN
            --IF(@AccountPatientID IS NOT NULL)
            --BEGIN
            ----link these 2 records in int_MedicalRecordNumbermap.
            --END

            -- Process Patient Visit Information
            EXEC [HL7].[uspSavePatientVisitInformation]
                @UniqueVisitNumber,
                @UnitID,
                @FacilityID,
                @PatientID,
                @SendingSystemID,
                @PatientClassCodeID,
                @PatientPointOfCare,
                @PatientVisitNumber,
                @MessageNumber,
                @PatientRoom,
                @PatientBed,
                @AccountID,
                @VIPIndicator,
                @AdmitDateTime,
                @DischargeDateTime;

            -- Link the HL7 message no and patient MedicalRecordNumber
            INSERT INTO [HL7].[PatientLink]
                (
                    [MessageNumber],
                    [PatientMedicalRecordNumber],
                    [PatientVisitNumber],
                    [PatientID]
                )
            VALUES
                (
                    @MessageNumber, @PatientMedicalRecordNumber, @PatientVisitNumber, @PatientID
                );

            -- Update the HL7 Temp table status to received
            UPDATE
                [HL7].[InboundMessage]
            SET
                [MessageStatus] = 'R',
                [MessageProcessedDate] = SYSUTCDATETIME()
            WHERE
                [MessageNumber] = @MessageNumber;

            COMMIT TRAN;
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN;

            -- Update the HL7 Temp table status to Error--
            UPDATE
                [HL7].[InboundMessage]
            SET
                [MessageStatus] = 'E'
            WHERE
                [MessageNumber] = @MessageNumber;
            SELECT
                @ErrorMessage  = ERROR_MESSAGE(),
                @ErrorSeverity = ERROR_SEVERITY(),
                @ErrorState    = ERROR_STATE();

            -- Use RAISERROR inside the CATCH block to return error
            -- information about the original error that caused
            -- execution to jump to the CATCH block.
            RAISERROR(   @ErrorMessage,  -- Message text.
                         @ErrorSeverity, -- Severity.
                         @ErrorState     -- State.
                     );
        END CATCH;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Saves ADT A01 message.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveADTMessage';

