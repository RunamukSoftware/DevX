CREATE PROCEDURE [dbo].[usp_DM3_AddPatient]
    (
     @PatientGUID NVARCHAR(50), -- TG - Should be UNIQUEIDENTIFIER
     @DOB NVARCHAR(50) = NULL, -- TG - should be DATETIME
     @Height NVARCHAR(50) = NULL, -- TG - should be FLOAT
     @Weight NVARCHAR(50) = NULL, -- TG - should be FLOAT
     @BSA NVARCHAR(50) = NULL -- TG - should be FLOAT
    )
AS
BEGIN
    IF (@DOB = N'NULL')
    BEGIN
        SET @DOB = NULL;
    END;

    INSERT  INTO [dbo].[int_patient]
            ([patient_id],
             [new_patient_id],
             [dob],
             [gender_cid],
             [height],
             [weight],
             [bsa]
            )
    VALUES
            (CAST(@PatientGUID AS UNIQUEIDENTIFIER),
             NULL,
             CAST(@DOB AS DATETIME),
             NULL,
             CAST(@Height AS FLOAT),
             CAST(@Weight AS FLOAT),
             CAST(@BSA AS FLOAT)
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_AddPatient';

