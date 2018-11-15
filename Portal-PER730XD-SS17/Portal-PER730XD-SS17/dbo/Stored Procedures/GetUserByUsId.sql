CREATE PROCEDURE [dbo].[GetUserByUsId] (@user_sid VARCHAR(50))
AS
BEGIN
    SELECT
        [user_id],
        [user_role_id],
        [login_name]
    FROM
        [dbo].[int_user]
    WHERE
        [user_sid] = @user_sid;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve User details by user security identifier.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetUserByUsId';

