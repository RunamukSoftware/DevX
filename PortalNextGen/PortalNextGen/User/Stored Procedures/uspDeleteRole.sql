CREATE PROCEDURE [User].[uspDeleteRole] (@RoleID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [iur]
        FROM
            [User].[Role] AS [iur]
        WHERE
            [iur].[RoleID] = @RoleID;

        DELETE
        [is]
        FROM
            [Intesys].[Security] AS [is]
        WHERE
            [is].[RoleID] = @RoleID
            AND [is].[UserID] IS NULL;

        DELETE
        [iu]
        FROM
            [User].[User] AS [iu]
        WHERE
            [iu].[RoleID] = @RoleID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete a User Role.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspDeleteRole';

