CREATE PROCEDURE [dbo].[RestrictUnit]
    (
     @user_role_id UNIQUEIDENTIFIER,
     @organization_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    INSERT  INTO [dbo].[cdr_restricted_organization]
            ([user_role_id],
             [organization_id]
            )
    VALUES
            (@user_role_id,
             @organization_id
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save the restricted organization of a role.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'RestrictUnit';

