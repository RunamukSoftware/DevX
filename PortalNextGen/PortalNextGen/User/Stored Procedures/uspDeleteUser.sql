CREATE PROCEDURE [User].[uspDeleteUser] (@UserID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [iu]
        FROM
            [User].[User] AS [iu]
        WHERE
            [iu].[UserID] = @UserID;

        DELETE
        [is]
        FROM
            [Intesys].[Security] AS [is]
        WHERE
            [is].[UserID] = @UserID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete ICS user by user ID.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspDeleteUser';

