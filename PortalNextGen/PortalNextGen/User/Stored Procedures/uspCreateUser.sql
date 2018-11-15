CREATE PROCEDURE [User].[uspCreateUser]
    (
        @RoleID    INT,
        @LoginName NVARCHAR(64)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [User].[User]
            (
                [RoleID],
                [UserSecurityID],
                [LoginName]
            )
        VALUES
            (
                @RoleID, NULL, @LoginName
            );

        SELECT
            SCOPE_IDENTITY() AS [UserID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Create user and assign a role for the user.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspCreateUser';

