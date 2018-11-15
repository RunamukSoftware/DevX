CREATE TABLE [dbo].[int_DataLoader_ETR_Temp_Settings] (
    [gateway_id]                UNIQUEIDENTIFIER NOT NULL,
    [gateway_type]              NVARCHAR (10)    NULL,
    [farm_name]                 NVARCHAR (5)     NULL,
    [network]                   NVARCHAR (30)    NULL,
    [et_do_not_store_waveforms] TINYINT          NULL,
    [include_trans_chs]         NVARCHAR (255)   NULL,
    [exclude_trans_chs]         NVARCHAR (255)   NULL,
    [et_print_alarms]           TINYINT          NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_DataLoader_ETR_Temp_Settings';

