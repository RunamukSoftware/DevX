CREATE PROCEDURE [dbo].[CreateRole]
    (
     @role_Id UNIQUEIDENTIFIER,
     @role_name VARCHAR(64), -- TG - Should be NVARCHAR(32)
     @role_desc VARCHAR(510), -- TG - Should be NVARCHAR(255)
     @xml_data XML
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_user_role]
            ([user_role_id],
             [role_name],
             [role_desc]
            )
    VALUES
            (@role_Id,
             CAST(@role_name AS NVARCHAR(32)),
             CAST(@role_desc AS NVARCHAR(255))
            );

    INSERT  INTO [dbo].[int_security]
            ([user_role_id], [xml_data])
    VALUES
            (@role_Id, @xml_data);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Create a role.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'CreateRole';

