CREATE PROCEDURE [dbo].[usp_DeleteMonitor]
    (
     @monitor_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SET NOCOUNT ON;

    DELETE
        [dbo].[int_monitor]
    WHERE
        [monitor_id] = @monitor_id;

    DELETE FROM
        [dbo].[Devices]
    WHERE
        [Id] = @monitor_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete UV or XTR monitor from the appropriate table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DeleteMonitor';

