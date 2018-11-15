CREATE PROCEDURE [dbo].[ChangeUserRole]
    (
     @user_id UNIQUEIDENTIFIER,
     @user_role_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_user]
    SET
        [user_role_id] = @user_role_id
    WHERE
        [user_id] = @user_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Change role for user.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'ChangeUserRole';

