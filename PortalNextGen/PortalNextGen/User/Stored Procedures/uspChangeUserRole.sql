CREATE PROCEDURE [User].[uspChangeUserRole]
    (
        @UserID INT,
        @RoleID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [User].[User]
        SET
            [RoleID] = @RoleID
        WHERE
            [UserID] = @UserID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Change role for user.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspChangeUserRole';

