CREATE PROCEDURE [dbo].[UpdateRole]
    (
     @role_Id UNIQUEIDENTIFIER,
     @role_name VARCHAR(50), -- TG - should be NVARCHAR(32)
     @role_desc VARCHAR(250),
     @xml_data XML
    )
AS
BEGIN
    UPDATE
        [dbo].[int_user_role]
    SET
        [role_name] = CAST(@role_name AS NVARCHAR(32)),
        [role_desc] = @role_desc
    WHERE
        [user_role_id] = @role_Id;

    UPDATE
        [dbo].[int_security]
    SET
        [xml_data] = @xml_data
    WHERE
        [user_role_id] = @role_Id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update Role and Security tables', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'UpdateRole';

