CREATE PROCEDURE [dbo].[GetUserByName]
    (
     @login_name NVARCHAR(64)
    )
AS
BEGIN
    SELECT
        [user_id],
        [user_role_id],
        [user_sid],
        [login_name]
    FROM
        [dbo].[int_user]
    WHERE
        [login_name] = @login_name;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve User details by User Login Name.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetUserByName';

