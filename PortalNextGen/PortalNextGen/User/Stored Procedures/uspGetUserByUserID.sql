CREATE PROCEDURE [User].[uspGetUserByUserID] (@UserID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iu].[UserID],
            [iu].[LoginName],
            [iu].[RoleID],
            [iu].[UserSecurityID]
        FROM
            [User].[User] AS [iu]
        WHERE
            [iu].[UserID] = @UserID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve User details by User ID.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspGetUserByUserID';

