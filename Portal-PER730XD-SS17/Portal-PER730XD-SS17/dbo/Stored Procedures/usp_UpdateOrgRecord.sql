CREATE PROCEDURE [dbo].[usp_UpdateOrgRecord]
    (
     @auto_collect_interval INT,
     @outbound_interval INT,
     @printer_name VARCHAR(255),
     @alarm_printer_name VARCHAR(255),
     @organization_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_organization]
    SET
        [auto_collect_interval] = @auto_collect_interval,
        [outbound_interval] = @outbound_interval,
        [printer_name] = @printer_name,
        [alarm_printer_name] = @alarm_printer_name
    WHERE
        [organization_id] = @organization_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateOrgRecord';

