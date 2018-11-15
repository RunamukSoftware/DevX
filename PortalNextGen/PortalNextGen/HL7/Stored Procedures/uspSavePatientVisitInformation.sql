CREATE PROCEDURE [HL7].[uspSavePatientVisitInformation]
    (
        @UniqueVisitNumber    BIT,
        @UnitID               INT,
        @OrganizationID       INT,
        @PatientID            INT,
        @SendingApplicationID INT,
        @PatientClassCodeID   INT,
        @PatientPointOfCare   NVARCHAR(80),
        @PatientVisitNumber   NVARCHAR(20),
        @MessageNumber        INT,
        @PatientRoom          NVARCHAR(80) = NULL,
        @PatientBed           NVARCHAR(80) = NULL,
        @AccountID            INT          = NULL,
        @VIPIndicator         BIT,
        @AdmitDateTime        DATETIME2(7) = NULL,
        @DischargeDateTime    DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            DECLARE
                @VisitNumberExists INT,
                @EncounterID       INT,
                @StatusCode        NVARCHAR(3),
                @MessageControlID  NVARCHAR(10);

            -- Getting the Message Control ID from the message No
            SET @MessageControlID =
                (
                    SELECT
                        [him].[MessageControlID]
                    FROM
                        [HL7].[InboundMessage] AS [him]
                    WHERE
                        [him].[MessageNumber] = @MessageNumber
                );

            SET @StatusCode = N'C';

            IF (@DischargeDateTime IS NOT NULL)
                BEGIN
                    SET @StatusCode = N'D';
                END;

            SET @VisitNumberExists =
                (
                    SELECT
                        COUNT(1)
                    FROM
                        [Intesys].[EncounterMap] AS [iem]
                    WHERE
                        [iem].[EncounterXID] = @PatientVisitNumber
                        AND [iem].[OrganizationID] = @OrganizationID
                );

            IF (@VisitNumberExists > 0)
                BEGIN
                    SET @EncounterID =
                        (
                            SELECT
                                [iem].[EncounterID]
                            FROM
                                [Intesys].[EncounterMap] AS [iem]
                            WHERE
                                [iem].[EncounterXID] = @PatientVisitNumber
                                AND [iem].[OrganizationID] = @OrganizationID
                                AND [iem].[PatientID] = @PatientID
                        );
                    IF NOT EXISTS
                        (
                            SELECT
                                [iem].[PatientID]
                            FROM
                                [Intesys].[EncounterMap] AS [iem]
                            WHERE
                                [iem].[EncounterXID] = @PatientVisitNumber
                                AND [iem].[OrganizationID] = @OrganizationID
                                AND [iem].[PatientID] = @PatientID
                        )
                        BEGIN
                            -- Gets the Existing Encounter ID
                            IF (@UniqueVisitNumber = 1)
                                BEGIN
                                    RAISERROR(
                                                 'VisitNumber = "%s" already exists in the database for a different patient,change visit number for MessageControlID="%s".',
                                                 16, 1, @PatientVisitNumber, @MessageControlID
                                             );
                                    RETURN;
                                END;
                            ELSE
                                BEGIN
                                    SET @EncounterID = 0; --NEWID();

                                    -- Only begin date/time is not stored from pre-release which is from MSH in the encounter.
                                    INSERT INTO [Intesys].[Encounter]
                                        (
                                            [EncounterID],
                                            [OrganizationID],
                                            [ModifiedDateTime],
                                            [PatientID],
                                            [StatusCode],
                                            [AccountID]
                                        )
                                    VALUES
                                        (
                                            @EncounterID, @OrganizationID, SYSUTCDATETIME(), @PatientID, @StatusCode,
                                            @AccountID
                                        );

                                    INSERT INTO [Intesys].[EncounterMap]
                                        (
                                            [EncounterXID],
                                            [OrganizationID],
                                            [EncounterID],
                                            [PatientID],
                                            [SequenceNumber],
                                            [StatusCode],
                                            [AccountID]
                                        )
                                    VALUES
                                        (
                                            @PatientVisitNumber, @OrganizationID, @EncounterID, @PatientID, 1,
                                            @StatusCode, @AccountID
                                        );
                                END;
                        END;
                END;
            ELSE
                BEGIN
                    SET @EncounterID = 0; --NEWID();

                    INSERT INTO [Intesys].[Encounter]
                        (
                            [EncounterID],
                            [OrganizationID],
                            [ModifiedDateTime],
                            [PatientID],
                            [StatusCode],
                            [AccountID]
                        )
                    VALUES
                        (
                            @EncounterID, @OrganizationID, SYSUTCDATETIME(), @PatientID,
                            CAST(@StatusCode AS NVARCHAR(3)), @AccountID
                        );

                    INSERT INTO [Intesys].[EncounterMap]
                        (
                            [EncounterXID],
                            [OrganizationID],
                            [EncounterID],
                            [PatientID],
                            [SequenceNumber],
                            [StatusCode],
                            [AccountID]
                        )
                    VALUES
                        (
                            @PatientVisitNumber, @OrganizationID, @EncounterID, @PatientID, 1, @StatusCode, @AccountID
                        );
                END;

            -- Update Encounter information
            EXEC [HL7].[uspUpdatePatientVisitInformation]
                @EncounterID = @EncounterID,
                @AccountID = @AccountID,
                @StatusCode = @StatusCode,
                @VipSwitch = @VIPIndicator,
                @PatientClassCodeID = @PatientClassCodeID,
                @UnitOrganizationID = @UnitID,
                @AdmitDateTime = @AdmitDateTime,
                @Room = @PatientRoom,
                @Bed = @PatientBed,
                @DischargeDateTime = @DischargeDateTime;
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Saves the patient visit Information.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspSavePatientVisitInformation';

