CREATE TABLE [dbo].[int_DataLoader_UV_Temp_Settings] (
    [gateway_id]                UNIQUEIDENTIFIER NOT NULL,
    [gateway_type]              NVARCHAR (20)    NULL,
    [network_name]              NVARCHAR (20)    NULL,
    [network_id]                NVARCHAR (30)    NULL,
    [node_name]                 CHAR (5)         NULL,
    [node_id]                   CHAR (1024)      NULL,
    [uv_organization_id]        UNIQUEIDENTIFIER NULL,
    [uv_unit_id]                UNIQUEIDENTIFIER NULL,
    [include_nodes]             NVARCHAR (255)   NULL,
    [exclude_nodes]             NVARCHAR (255)   NULL,
    [uv_do_not_store_waveforms] TINYINT          NULL,
    [print_requests]            TINYINT          NULL,
    [make_time_master]          TINYINT          NULL,
    [auto_assign_id]            TINYINT          NULL,
    [new_mrn_format]            NVARCHAR (30)    NULL,
    [uv_print_alarms]           TINYINT          NULL,
    [debug_level]               INT              NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_DataLoader_UV_Temp_Settings';

