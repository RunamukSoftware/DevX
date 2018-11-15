CREATE PROCEDURE [dbo].[usp_GetUnitDetail]
    (
     @organization_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [auto_collect_interval],
        [printer_name],
        [alarm_printer_name],
        [outbound_interval]
    FROM
        [dbo].[int_organization]
    WHERE
        [organization_id] = @organization_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetUnitDetail';

