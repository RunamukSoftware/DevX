CREATE PROCEDURE [dbo].[DeleteRole]
    (
     @role_Id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [iur]
    FROM
        [dbo].[int_user_role] AS [iur]
    WHERE
        [user_role_id] = @role_Id;

    DELETE
        [is]
    FROM
        [dbo].[int_security] AS [is]
    WHERE
        [user_role_id] = @role_Id
        AND [user_id] IS NULL;

    DELETE
        [iu]
    FROM
        [dbo].[int_user] AS [iu]
    WHERE
        [user_role_id] = @role_Id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete a User Role.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteRole';

