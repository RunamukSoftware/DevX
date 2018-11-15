CREATE PROCEDURE [dbo].[usp_HL7_UpdatePatientInfo]
    (
     @PatientId UNIQUEIDENTIFIER,
     @mrn1 NVARCHAR(20),
     @mrn2 NVARCHAR(20) = NULL,
     @FirstNm NVARCHAR(48) = NULL,
     @MiddleNm NVARCHAR(48) = NULL,
     @LastNm NVARCHAR(48) = NULL,
     @dob DATETIME = NULL,
     @GenderCid INT = NULL
    )
AS
BEGIN
    BEGIN TRY
        -- Updates MRN information
        UPDATE
            [dbo].[int_mrn_map]
        SET
            [mrn_xid] = @mrn1,
            [mrn_xid2] = @mrn2
        WHERE
            [patient_id] = @PatientId;
        
    
        -- Updates Patient information
        UPDATE
            [dbo].[int_patient]
        SET
            [dob] = @dob,
            [gender_cid] = @GenderCid
        WHERE
            [patient_id] = @PatientId;
    
        -- Inserts Person information
        UPDATE
            [dbo].[int_person]
        SET
            [first_nm] = @FirstNm,
            [middle_nm] = @MiddleNm,
            [last_nm] = @LastNm
        WHERE
            [person_id] = @PatientId;
    
        -- Update the patient monitor if it is a active patient
        IF ((SELECT
                [patient_id]
             FROM
                [dbo].[int_patient_monitor]
             WHERE
                [patient_id] = @PatientId
                AND [active_sw] = 1
            ) IS NOT NULL)
        BEGIN    
            -- Update the patient monitor status to update with patient Updater
            UPDATE
                [dbo].[int_patient_monitor]
            SET
                [monitor_status] = 'UPD'
            WHERE
                [patient_id] = @PatientId
                AND [active_sw] = 1;
        END;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Use RAISERROR inside the CATCH block to return error
        -- information about the original error that caused
        -- execution to jump to the CATCH block.
        RAISERROR (@ErrorMessage, -- Message text.
                   @ErrorSeverity, -- Severity.
                   @ErrorState -- State.
                   );
    END CATCH;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Updates patient Demographics related to HL7 tables.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdatePatientInfo';

