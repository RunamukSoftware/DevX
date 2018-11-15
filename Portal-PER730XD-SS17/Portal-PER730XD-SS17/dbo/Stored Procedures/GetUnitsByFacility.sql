CREATE PROCEDURE [dbo].[GetUnitsByFacility]
    (
     @facility_id [dbo].[DFACILITY_ID], -- TG - Should be UNIQUEIDENTIFIER
     @login_name NVARCHAR(64)
    )
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [io].[organization_nm] AS [UNIT_NAME],
        [io].[organization_id] AS [UNIT_ID]
    FROM
        [dbo].[int_organization] AS [io]
    WHERE
        [io].[parent_organization_id] = CAST(@facility_id AS UNIQUEIDENTIFIER)
        AND [io].[category_cd] = 'D'
        AND [io].[organization_id] NOT IN (SELECT
                                            [cro].[organization_id]
                                           FROM
                                            [dbo].[cdr_restricted_organization] AS [cro]
                                           WHERE
                                            [cro].[user_role_id] = (SELECT
                                                                        [user_role_id]
                                                                    FROM
                                                                        [dbo].[int_user]
                                                                    WHERE
                                                                        [int_user].[login_name] = @login_name
                                                                   ))
    ORDER BY
        [io].[organization_nm]; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetUnitsByFacility';

