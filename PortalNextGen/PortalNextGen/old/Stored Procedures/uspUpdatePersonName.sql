CREATE PROCEDURE [old].[uspUpdatePersonName]
    (
        @LastName     NVARCHAR(50),
        @FirstName    NVARCHAR(50),
        @MiddleName   NVARCHAR(50),
        @PersonNameID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PersonName]
        SET
            [LastName] = @LastName,
            [FirstName] = @FirstName,
            [MiddleName] = @MiddleName
        WHERE
            [PersonNameID] = @PersonNameID
            AND [ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePersonName';

