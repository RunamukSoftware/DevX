CREATE PROCEDURE [DM3].[uspAddPerson]
    (
        @PatientID   INT,
        @FirstName   NVARCHAR(50) = NULL,
        @Middle_Name NVARCHAR(50) = NULL,
        @LastName    NVARCHAR(50) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Person]
            (
                [PersonID],
                [NewPatientID],
                [FirstName],
                [MiddleName],
                [LastName],
                [Suffix],
                [TelephoneNumber],
                [Line1Description],
                [Line2Description],
                [Line3Description],
                [City],
                [StateCode],
                [ZipCode],
                [CountryCodeID]
            )
        VALUES
            (
                @PatientID,
                NULL,
                @FirstName,
                @Middle_Name,
                @LastName,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddPerson';

