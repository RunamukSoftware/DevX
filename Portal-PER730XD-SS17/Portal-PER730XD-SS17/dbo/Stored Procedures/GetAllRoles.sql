CREATE PROCEDURE [dbo].[GetAllRoles]
AS
BEGIN
    SELECT
        [user_role_id],
        [role_name],
        [role_desc]
    FROM
        [dbo].[int_user_role];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get all Roles.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetAllRoles';

