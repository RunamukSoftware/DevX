CREATE PROCEDURE [dbo].[usp_UpdateMonitor]
    (
     @monitor_dsc NVARCHAR(50), -- TG - Should be VARCHAR(50)
     @unit_Org_id UNIQUEIDENTIFIER,
     @room NVARCHAR(12), -- TG - Should be VARCHAR(12)
     @bed_cd NVARCHAR(20),
     @monitor_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_monitor]
    SET
        [monitor_dsc] = @monitor_dsc,
        [unit_org_id] = @unit_Org_id,
        [room] = @room,
        [bed_cd] = @bed_cd
    WHERE
        [monitor_id] = @monitor_id;
    
    UPDATE
        [dbo].[Devices]
    SET
        [Description] = CAST(@monitor_dsc AS VARCHAR(50)),
        [Room] = CAST(@room AS VARCHAR(12))
    WHERE
        [Id] = @monitor_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateMonitor';

