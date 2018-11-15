CREATE PROCEDURE [DM3].[uspUpdatePerson]
    (
        @LastName        NVARCHAR(50) = NULL,
        @FirstName       NVARCHAR(50) = NULL,
        @MiddleName      NVARCHAR(50) = NULL,
        @ConstLastName   NVARCHAR(50) = NULL,
        @ConstFirstName  NVARCHAR(50) = NULL,
        @ConstMiddleName NVARCHAR(50) = NULL,
        @PatientID       INT          = NULL,
        @DateOfBirth     DATE         = NULL,
        @Height          FLOAT(53)    = NULL,
        @Weight          FLOAT(53)    = NULL,
        @BSA             FLOAT(53)    = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PersonName]
        SET
            [LastName] = @LastName,
            [FirstName] = @FirstName,
            [MiddleName] = @MiddleName,
            [mpi_lname_cons] = @ConstLastName,
            [mpi_fname_cons] = @ConstFirstName,
            [mpi_mname_cons] = @ConstMiddleName
        WHERE
            [PersonNameID] = @PatientID;

        UPDATE
            [Intesys].[Person]
        SET
            [LastName] = @LastName,
            [FirstName] = @FirstName,
            [MiddleName] = @MiddleName
        WHERE
            [PersonID] = @PatientID;

        UPDATE
            [Intesys].[Patient]
        SET
            [DateOfBirth] = @DateOfBirth,
            [Height] = @Height,
            [Weight] = @Weight,
            [BodySurfaceArea] = @BSA
        WHERE
            [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePerson';

