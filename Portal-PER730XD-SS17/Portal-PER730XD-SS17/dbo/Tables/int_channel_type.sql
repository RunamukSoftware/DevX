CREATE TABLE [dbo].[int_channel_type] (
    [channel_type_id] UNIQUEIDENTIFIER NOT NULL,
    [channel_code]    INT              NOT NULL,
    [gds_cid]         INT              NULL,
    [label]           VARCHAR (20)     NULL,
    [freq]            SMALLINT         NULL,
    [min_value]       SMALLINT         NULL,
    [max_value]       SMALLINT         NULL,
    [sweep_speed]     FLOAT (53)       NULL,
    [priority]        TINYINT          NULL,
    [type_cd]         VARCHAR (10)     NULL,
    [color]           VARCHAR (25)     NULL,
    [units]           VARCHAR (10)     NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_channel_type_channel_type_id]
    ON [dbo].[int_channel_type]([channel_type_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data about channel types. Each row is uniquely identified by the channel_type_id.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique ID representing a channel type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'channel_type_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code of the channel.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'channel_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The GDS code identifying the channel. Foreign key to the int_misc_code table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'gds_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The channel''s label.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'label';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'How many values per second this channel produces.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'freq';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Minimum value for the channel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'min_value';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Maximum value for a channel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'max_value';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The default sweeping speed for the vital signs viewer waveforms display.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'sweep_speed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The order the channel is displayed in the vital sign viewer. The vital signs viewer only has room to display so many channels, so this column also determines which channels are displayed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'priority';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The type of channel. WAVEFORM or NUMBER.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'type_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The color of display.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'color';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Units to use when displaying data in vital signs viewer.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_type', @level2type = N'COLUMN', @level2name = N'units';

