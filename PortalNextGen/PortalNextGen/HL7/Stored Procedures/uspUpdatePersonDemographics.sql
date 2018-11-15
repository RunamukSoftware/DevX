CREATE PROCEDURE [HL7].[uspUpdatePersonDemographics]
    (
        @PersonID         INT,
        @FirstName        NVARCHAR(50),
        @LastName         NVARCHAR(50),
        @MiddleName       NVARCHAR(50),
        @TelephoneNumber  NVARCHAR(40),
        @City             NVARCHAR(30),
        @StateCode        NVARCHAR(3),
        @ZipCode          NVARCHAR(6),
        @Suffix           NVARCHAR(5),
        @Line1Description NVARCHAR(80),
        @Line2Description NVARCHAR(80),
        @Line3Description NVARCHAR(80),
        @CountryCodeID    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Person]
        SET
            [FirstName] = @FirstName,
            [LastName] = @LastName,
            [MiddleName] = @MiddleName,
            [TelephoneNumber] = @TelephoneNumber,
            [City] = @City,
            [StateCode] = @StateCode,
            [ZipCode] = @ZipCode,
            [Suffix] = @Suffix,
            [Line1Description] = @Line1Description,
            [Line2Description] = @Line2Description,
            [Line3Description] = @Line3Description,
            [CountryCodeID] = @CountryCodeID
        WHERE
            [PersonID] = @PersonID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the persons demographics.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePersonDemographics';

