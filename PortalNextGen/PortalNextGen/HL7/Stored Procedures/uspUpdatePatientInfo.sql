CREATE PROCEDURE [HL7].[uspUpdatePatientInfo]
    (
        @PatientID            INT,
        @MedicalRecordNumber1 NVARCHAR(20),
        @MedicalRecordNumber2 NVARCHAR(20) = NULL,
        @FirstName              NVARCHAR(48) = NULL,
        @MiddleName             NVARCHAR(48) = NULL,
        @LastName               NVARCHAR(48) = NULL,
        @DateOfBirth          DATE         = NULL,
        @GenderCodeID            INT          = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            -- Updates MedicalRecordNumber information
            UPDATE
                [Intesys].[MedicalRecordNumberMap]
            SET
                [MedicalRecordNumberXID] = @MedicalRecordNumber1,
                [MedicalRecordNumberXID2] = @MedicalRecordNumber2
            WHERE
                [PatientID] = @PatientID;


            -- Updates Patient information
            UPDATE
                [Intesys].[Patient]
            SET
                [DateOfBirth] = @DateOfBirth,
                [GenderCodeID] = @GenderCodeID
            WHERE
                [PatientID] = @PatientID;

            -- Inserts Person information
            UPDATE
                [Intesys].[Person]
            SET
                [FirstName] = @FirstName,
                [MiddleName] = @MiddleName,
                [LastName] = @LastName
            WHERE
                [PersonID] = @PatientID;

            -- Update the patient monitor if it is a active patient
            IF (
                   (
                       SELECT
                           [PatientID]
                       FROM
                           [Intesys].[PatientMonitor]
                       WHERE
                           [PatientID] = @PatientID
                           AND [ActiveSwitch] = 1
                   ) IS NOT NULL
               )
                BEGIN
                    -- Update the patient monitor status to update with patient Updater
                    UPDATE
                        [Intesys].[PatientMonitor]
                    SET
                        [MonitorStatus] = 'UPD'
                    WHERE
                        [PatientID] = @PatientID
                        AND [ActiveSwitch] = 1;
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Updates patient Demographics related to HL7 tables.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientInfo';

