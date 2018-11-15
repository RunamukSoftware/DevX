CREATE PROCEDURE [User].[uspGetAllRoles]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iur].[RoleID],
            [iur].[Name],
            [iur].[Description]
        FROM
            [User].[Role] AS [iur];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get all Roles.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspGetAllRoles';

