CREATE PROCEDURE [HL7].[uspSavePatientDemographicInformation]
    (
        @PatientTypeAccountNumber   BIT,
        @PatientMedicalRecordNumber NVARCHAR(20),
        @PatientAccount             NVARCHAR(20) = NULL,
        @OrganizationID             INT,
        @PatientGivenName           NVARCHAR(48),
        @PatientFamilyName          NVARCHAR(48),
        @PatientMiddleName          NVARCHAR(48),
        @PatientDateOfBirth         DATE,
        @PatientGenderCodeID        INT,
        @PatientID                  INT          OUT,
        @AccountID                  INT          OUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SET @PatientID = 0;
        SET @AccountID = 0;

        BEGIN TRY
            DECLARE
                @PatientMedicalRecordNumberID INT,
                @PatientAccountID             INT;

            --get the patient MedicalRecordNumber if exists in the database.
            SET @PatientMedicalRecordNumberID =
                (
                    SELECT
                        [imm].[PatientID]
                    FROM
                        [Intesys].[MedicalRecordNumberMap] AS [imm]
                    WHERE
                        [imm].[MedicalRecordNumberXID] = @PatientMedicalRecordNumber
                        AND [imm].[OrganizationID] = @OrganizationID
                        AND [imm].[MergeCode] <> 'L'
                );

            --if the patient identification is Account Number
            IF (@PatientTypeAccountNumber = 1)
                BEGIN
                    --get the account number if exists in the database.
                    SET @PatientAccountID =
                        (
                            SELECT
                                [imm].[PatientID]
                            FROM
                                [Intesys].[MedicalRecordNumberMap] AS [imm]
                            WHERE
                                [imm].[MedicalRecordNumberXID] = @PatientAccount
                                AND [imm].[OrganizationID] = @OrganizationID
                                AND [imm].[MergeCode] <> 'L'
                        );
                END;

            --patient MedicalRecordNumber exists in the database
            IF (@PatientMedicalRecordNumberID IS NOT NULL)
                BEGIN
                    --update the patient MedicalRecordNumber
                    SET @PatientID = @PatientMedicalRecordNumberID;

                    EXEC [HL7].[uspUpdatePatientInfo]
                        @PatientID = @PatientID,
                        @MedicalRecordNumber1 = @PatientMedicalRecordNumber,
                        @MedicalRecordNumber2 = @PatientAccount,
                        @FirstName = @PatientGivenName,
                        @MiddleName = @PatientMiddleName,
                        @LastName = @PatientFamilyName,
                        @DateOfBirth = @PatientDateOfBirth,
                        @GenderCodeID = @PatientGenderCodeID;
                END;
            ELSE
                BEGIN
                    --There is no existing int_MedicalRecordNumbermap record based on MedicalRecordNumber, and account number is primary id
                    IF (@PatientAccountID IS NOT NULL)
                        BEGIN
                            SET @PatientID = @PatientAccountID;

                            EXEC [HL7].[uspUpdatePatientInfo]
                                @PatientID = @PatientID,
                                @MedicalRecordNumber1 = @PatientMedicalRecordNumber,
                                @MedicalRecordNumber2 = @PatientAccount,
                                @FirstName = @PatientGivenName,
                                @MiddleName = @PatientMiddleName,
                                @LastName = @PatientFamilyName,
                                @DateOfBirth = @PatientDateOfBirth,
                                @GenderCodeID = @PatientGenderCodeID;
                        END;
                    ELSE
                        BEGIN
                            --Inserts new patient information to respective tables here
                            SET @PatientID = 0; --NEWID();

                            EXEC [HL7].[uspSavePatientInformation]
                                @OrganizationID = @OrganizationID,
                                @PatientID = @PatientID,
                                @MedicalRecordNumber1 = @PatientMedicalRecordNumber,
                                @MedicalRecordNumber2 = @PatientAccount,
                                @FirstName = @PatientGivenName,
                                @MiddleName = @PatientMiddleName,
                                @LastName = @PatientFamilyName,
                                @DateOfBirth = @PatientDateOfBirth,
                                @GenderCodeID = @PatientGenderCodeID,
                                @AccountID = @AccountID OUT;
                        END;
                END;

            IF (@PatientAccount IS NOT NULL)
                BEGIN
                    -- Always get the latest account ID
                    SET @AccountID =
                        (
                            SELECT TOP (1)
                                [ia].[AccountID]
                            FROM
                                [Intesys].[Account] AS [ia]
                            WHERE
                                [ia].[AccountXID] = @PatientAccount
                                AND [ia].[OrganizationID] = @OrganizationID
                            ORDER BY
                                [ia].[AccountOpenDateTime] DESC
                        );
                    IF (@AccountID IS NULL)
                        BEGIN
                            SET @AccountID = 0; --NEWID();
                            EXEC [old].[uspInsertAccountInformation]
                                @AccountID = @AccountID,
                                @OrganizationID = @OrganizationID,
                                @AccountNumber = @PatientAccount;
                        END;
                END;

        END TRY
        BEGIN CATCH
            DECLARE @ErrorMessage NVARCHAR(4000);
            DECLARE @ErrorSeverity INT;
            DECLARE @ErrorState INT;
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert/Update the patient information into respective tables.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspSavePatientDemographicInformation';

