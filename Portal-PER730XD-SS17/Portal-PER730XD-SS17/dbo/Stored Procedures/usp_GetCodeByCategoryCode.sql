CREATE PROCEDURE [dbo].[usp_GetCodeByCategoryCode]
    (
     @categoryCd CHAR(4),
     @MethodCd NVARCHAR(10),
     @Code NVARCHAR(80),
     @OrganizationId UNIQUEIDENTIFIER,
     @SendingSysId UNIQUEIDENTIFIER,
     @CodeId INT OUT
    )
AS
BEGIN
    SET @CodeId = (SELECT
                    [MiscCode].[code_id]
                   FROM
                    [dbo].[int_misc_code] AS [MiscCode]
                    INNER JOIN [dbo].[int_code_category] AS [CodeCat] ON [MiscCode].[category_cd] = [CodeCat].[cat_code]
                   WHERE
                    [MiscCode].[category_cd] = @categoryCd
                    AND [MiscCode].[code] = @Code
                    AND [MiscCode].[organization_id] = @OrganizationId
                    AND [MiscCode].[sys_id] = @SendingSysId
                    AND [MiscCode].[method_cd] = @MethodCd
                  );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets code id by category code.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetCodeByCategoryCode';

