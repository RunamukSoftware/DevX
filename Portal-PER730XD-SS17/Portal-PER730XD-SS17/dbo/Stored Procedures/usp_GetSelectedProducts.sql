CREATE PROCEDURE [dbo].[usp_GetSelectedProducts]
    (
     @product_cd VARCHAR(25)
    )
AS
BEGIN
    SELECT
        [int_organization].[organization_id],
        [int_organization].[category_cd],
        [int_organization].[parent_organization_id],
        [int_organization].[organization_cd],
        [int_organization].[organization_nm],
        [int_organization].[in_default_search],
        [int_organization].[monitor_disable_sw],
        [int_organization].[auto_collect_interval],
        [int_organization].[outbound_interval],
        [int_organization].[printer_name],
        [int_organization].[alarm_printer_name]
    FROM
        [dbo].[int_product_access]
        INNER JOIN [dbo].[int_organization] ON [int_product_access].[organization_id] = [int_organization].[organization_id]
    WHERE
        [int_product_access].[product_cd] = @product_cd
    ORDER BY
        [organization_nm];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetSelectedProducts';

