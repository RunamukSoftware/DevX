CREATE PROCEDURE [dbo].[usp_GetGatewayDetailsByCategoryCode]
    (
     @categoryCode CHAR(1) = NULL,
     @parentOrganizationId UNIQUEIDENTIFIER = NULL
    )
AS
BEGIN
    IF (@parentOrganizationId IS NULL)
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
            [dbo].[int_organization]
        WHERE
            [category_cd] = @categoryCode
        ORDER BY
            [category_cd]; 
    END;
    ELSE
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
            [dbo].[int_organization]
        WHERE
            [category_cd] = @categoryCode
            AND [parent_organization_id] = @parentOrganizationId
        ORDER BY
            [category_cd]; 
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetGatewayDetailsByCategoryCode';

