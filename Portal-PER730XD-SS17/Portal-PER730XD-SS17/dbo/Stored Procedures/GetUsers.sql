CREATE PROCEDURE [dbo].[GetUsers]
AS
BEGIN
    SELECT
        [user_id],
        [user_role_id],
        [user_sid],
        [login_name]
    FROM
        [dbo].[int_user];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetUsers';

