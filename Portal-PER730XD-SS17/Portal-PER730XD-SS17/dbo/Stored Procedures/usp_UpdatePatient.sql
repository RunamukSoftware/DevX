CREATE PROCEDURE [dbo].[usp_UpdatePatient]
    (
     @dob DATETIME,
     @gender_cid INT,
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_patient]
    SET
        [dob] = @dob,
        [gender_cid] = @gender_cid
    WHERE
        [patient_id] = @patient_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdatePatient';

