CREATE PROCEDURE [dbo].[DeleteUser]
    (
     @user_Id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [iu]
    FROM
        [dbo].[int_user] AS [iu]
    WHERE
        [user_id] = @user_Id;

    DELETE
        [is]
    FROM
        [dbo].[int_security] AS [is]
    WHERE
        [is].[user_id] = @user_Id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete ICS user by user ID.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteUser';

