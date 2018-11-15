CREATE PROCEDURE [HL7].[uspSavePatientInformation]
    (
        @OrganizationID       INT,
        @PatientID            INT,
        @MedicalRecordNumber1 NVARCHAR(20),
        @MedicalRecordNumber2 NVARCHAR(20) = NULL,
        @FirstName              NVARCHAR(48) = NULL,
        @MiddleName             NVARCHAR(48) = NULL,
        @LastName               NVARCHAR(48) = NULL,
        @DateOfBirth          DATE         = NULL,
        @GenderCodeID            INT          = NULL,
        @AccountID            INT          OUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SET @AccountID = 0;

        BEGIN TRY
            -- Inserts MedicalRecordNumber information
            INSERT INTO [Intesys].[MedicalRecordNumberMap]
                (
                    [OrganizationID],
                    [MedicalRecordNumberXID],
                    [PatientID],
                    [MedicalRecordNumberXID2],
                    [MergeCode],
                    [AdmitDischargeTransferAdmitSwitch]
                )
            VALUES
                (
                    @OrganizationID, @MedicalRecordNumber1, @PatientID, @MedicalRecordNumber2, 'C', 1
                );

            -- Inserts Patient information
            INSERT INTO [Intesys].[Patient]
                (
                    [PatientID],
                    [DateOfBirth],
                    [GenderCodeID]
                )
            VALUES
                (
                    @PatientID, @DateOfBirth, @GenderCodeID
                );

            -- Inserts Person information
            INSERT INTO [Intesys].[Person]
                (
                    [PersonID],
                    [FirstName],
                    [MiddleName],
                    [LastName]
                )
            VALUES
                (
                    @PatientID, @FirstName, @MiddleName, @LastName
                );
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert HL7 patient information.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspSavePatientInformation';

