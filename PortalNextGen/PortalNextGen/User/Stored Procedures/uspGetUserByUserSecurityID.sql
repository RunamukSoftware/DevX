CREATE PROCEDURE [User].[uspGetUserByUserSecurityID] (@UserSecurityID NVARCHAR(68))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iu].[UserID],
            [iu].[RoleID],
            [iu].[LoginName]
        FROM
            [User].[User] AS [iu]
        WHERE
            [iu].[UserSecurityID] = @UserSecurityID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve User details by user security identifier.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspGetUserByUserSecurityID';

