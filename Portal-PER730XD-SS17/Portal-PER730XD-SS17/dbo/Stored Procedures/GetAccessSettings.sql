CREATE PROCEDURE [dbo].[GetAccessSettings]
    (
     @role_Id UNIQUEIDENTIFIER
    )
AS
BEGIN
    IF (@role_Id IS NULL)
    BEGIN
        SELECT
            [xml_data]
        FROM
            [dbo].[int_security]
        WHERE
            [user_role_id] IS NULL
            AND [user_id] IS NULL;
    END;
    ELSE
    BEGIN
        SELECT
            [xml_data]
        FROM
            [dbo].[int_security]
        WHERE
            [user_role_id] = @role_Id
            AND [user_id] IS NULL;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the security settings of a Role.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetAccessSettings';

