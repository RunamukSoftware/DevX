CREATE PROCEDURE [old].[uspGetAccessSettings] (@RoleID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@RoleID IS NULL)
            BEGIN
                SELECT
                    [is].[XmlData]
                FROM
                    [Intesys].[Security] AS [is]
                WHERE
                    [is].[RoleID] IS NULL
                    AND [is].[UserID] IS NULL;
            END;
        ELSE
            BEGIN
                SELECT
                    [is].[XmlData]
                FROM
                    [Intesys].[Security] AS [is]
                WHERE
                    [is].[RoleID] = @RoleID
                    AND [is].[UserID] IS NULL;
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the security settings of a Role.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetAccessSettings';

