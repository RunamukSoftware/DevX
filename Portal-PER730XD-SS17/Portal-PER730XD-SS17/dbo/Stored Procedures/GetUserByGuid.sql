CREATE PROCEDURE [dbo].[GetUserByGuid] (@user_id VARCHAR(50)) -- TG - should be UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
        [user_id],
        [login_name],
        [user_role_id],
        [user_sid]
    FROM
        [dbo].[int_user]
    WHERE
        [user_id] = CAST(@user_id AS UNIQUEIDENTIFIER);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve User details by User ID.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetUserByGuid';

