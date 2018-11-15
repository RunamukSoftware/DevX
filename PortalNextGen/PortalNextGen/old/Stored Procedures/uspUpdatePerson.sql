CREATE PROCEDURE [old].[uspUpdatePerson]
    (
        @PersonID   INT,
        @LastName   NVARCHAR(50),
        @FirstName  NVARCHAR(50),
        @MiddleName NVARCHAR(50)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Person]
        SET
            [LastName] = @LastName,
            [FirstName] = @FirstName,
            [MiddleName] = @MiddleName
        WHERE
            [PersonID] = @PersonID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePerson';

