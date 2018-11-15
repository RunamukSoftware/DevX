CREATE PROCEDURE [User].[uspAssignUserRole]
    (
        @UserID         INT,
        @RoleID         INT,
        @UserSecurityID NVARCHAR(68),
        @LoginName      NVARCHAR(64)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [User].[User]
            (
                [UserID],
                [RoleID],
                [UserSecurityID],
                [LoginName]
            )
        VALUES
            (
                @UserID, @RoleID, @UserSecurityID, @LoginName
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Create a user and assign the role for the user.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspAssignUserRole';

