CREATE PROCEDURE [dbo].[usp_GetCodeList] (@filters NVARCHAR(MAX))
AS
BEGIN
    DECLARE @QUERY NVARCHAR(MAX);

    SET @QUERY = '
        SELECT 
            int_organization.organization_cd AS [Facility],
            int_send_sys.code AS [System],
            int_misc_code.category_cd AS [Category],
            int_misc_code.method_cd AS [Method], 
            int_misc_code.code AS [Code],
            int_misc_code.int_keystone_cd AS [Internal Code],
            int_misc_code.short_dsc AS [Description], 
            ISNULL(int_misc_code.verification_sw,''0'') AS [Verified],
            int_misc_code.code_id AS [ID] 
        FROM dbo.int_misc_code 
            LEFT OUTER JOIN dbo.int_send_sys 
                ON int_misc_code.sys_id = int_send_sys.sys_id 
            LEFT OUTER JOIN dbo.int_organization 
                ON int_misc_code.organization_id = int_organization.organization_id 
            ';

    IF (LEN(@filters) > 0)
    BEGIN
        SET @QUERY += 'WHERE ';
        SET @QUERY += @filters;
    END;

    EXEC(@QUERY); -- TG-Why not use sp_executesql??
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetCodeList';

