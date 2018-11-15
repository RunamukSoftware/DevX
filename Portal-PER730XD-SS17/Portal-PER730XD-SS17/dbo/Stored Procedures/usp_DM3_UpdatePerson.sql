CREATE PROCEDURE [dbo].[usp_DM3_UpdatePerson]
    (
     @LastName NVARCHAR(50) = NULL,
     @FirstName NVARCHAR(50) = NULL,
     @MiddleName NVARCHAR(50) = NULL,
     @ConstLastName NVARCHAR(50) = NULL, -- TG - Should be NVARCHAR(20)
     @ConstFirstName NVARCHAR(50) = NULL, -- TG - Should be NVARCHAR(20)
     @ConstMiddleName NVARCHAR(50) = NULL, -- TG - Should be NVARCHAR(20)
     @PatientGUID NVARCHAR(50) = NULL, -- TG - Should be UNIQUEIDENTIFIER
     @DOB NVARCHAR(40) = NULL, -- TG - Should be DATETIME
     @Height NVARCHAR(10) = NULL, -- TG - Should be FLOAT
     @Weight NVARCHAR(10) = NULL, -- TG - Should be FLOAT
     @BSA NVARCHAR(10) = NULL -- TG - Should be FLOAT
    )
AS
BEGIN
    UPDATE
        [dbo].[int_person_name]
    SET
        [last_nm] = @LastName,
        [first_nm] = @FirstName,
        [middle_nm] = @MiddleName,
        [mpi_lname_cons] = CAST(@ConstLastName AS NVARCHAR(20)),
        [mpi_fname_cons] = CAST(@ConstFirstName AS NVARCHAR(20)),
        [mpi_mname_cons] = CAST(@ConstMiddleName AS NVARCHAR(20))
    WHERE
        [person_nm_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER);
            
    UPDATE
        [dbo].[int_person]
    SET
        [last_nm] = @LastName,
        [first_nm] = @FirstName,
        [middle_nm] = @MiddleName
    WHERE
        [person_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER);
            
            
    UPDATE
        [dbo].[int_patient]
    SET
        [dob] = CAST(@DOB AS DATETIME),
        [height] = CAST(@Height AS FLOAT),
        [weight] = CAST(@Weight AS FLOAT),
        [bsa] = CAST(@BSA AS FLOAT)
    WHERE
        [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_UpdatePerson';

