CREATE TABLE [dbo].[int_monitor] (
    [monitor_id]      UNIQUEIDENTIFIER NOT NULL,
    [unit_org_id]     UNIQUEIDENTIFIER NULL,
    [network_id]      NVARCHAR (15)    NOT NULL,
    [node_id]         NVARCHAR (15)    NOT NULL,
    [bed_id]          NVARCHAR (3)     NOT NULL,
    [bed_cd]          NVARCHAR (20)    NULL,
    [room]            NVARCHAR (12)    NULL,
    [monitor_dsc]     NVARCHAR (50)    NULL,
    [monitor_name]    NVARCHAR (30)    NOT NULL,
    [monitor_type_cd] VARCHAR (5)      NULL,
    [subnet]          NVARCHAR (50)    NULL,
    [standby]         TINYINT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_monitor_monitor_id]
    ON [dbo].[int_monitor]([monitor_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_monitor_unit_org_id_network_id_node_id_bed_id]
    ON [dbo].[int_monitor]([unit_org_id] ASC, [network_id] ASC, [node_id] ASC, [bed_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all monitors known by all gateways. Records are dynamically added/updated in this table as the monitor Loader service(s) run. Monitor records are NOT dynamically removed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_monitor';

