CREATE TABLE [Intesys].[ChannelType] (
    [ChannelTypeID]          INT           IDENTITY (1, 1) NOT NULL,
    [ChannelCode]            INT           NOT NULL,
    [GlobalDataSystemCodeID] INT           NOT NULL,
    [Label]                  VARCHAR (20)  NOT NULL,
    [Frequency]              SMALLINT      NOT NULL,
    [MinimumValue]           SMALLINT      NOT NULL,
    [MaximumValue]           SMALLINT      NOT NULL,
    [SweepSpeed]             FLOAT (53)    NOT NULL,
    [Priority]               TINYINT       NOT NULL,
    [TypeCode]               VARCHAR (10)  NOT NULL,
    [Color]                  VARCHAR (25)  NOT NULL,
    [Units]                  VARCHAR (10)  NOT NULL,
    [CreatedDateTime]        DATETIME2 (7) CONSTRAINT [DF_ChannelType_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ChannelType_ChannelTypeID] PRIMARY KEY CLUSTERED ([ChannelTypeID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_ChannelType_ChannelCode_Label]
    ON [Intesys].[ChannelType]([ChannelCode] ASC)
    INCLUDE([Label]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data about channel types. Each row is uniquely identified by the ChannelTypeID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique ID representing a channel Type.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'ChannelTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code of the channel.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'ChannelCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Global Data System (GDS) code identifying the channel. Foreign key to the int_misc_code table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'GlobalDataSystemCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The channel''s label.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'Label';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'How many values per second this channel produces.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'Frequency';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Minimum value for the channel', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'MinimumValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Maximum value for a channel', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'MaximumValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The default sweeping speed for the vital signs viewer waveforms display.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'SweepSpeed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The order the channel is displayed in the vital sign viewer. The vital signs viewer only has room to display so many channels, so this column also determines which channels are displayed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'Priority';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Type of channel. WAVEFORM or NUMBER.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'TypeCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The color of display.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'Color';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Units to use when displaying data in vital signs viewer.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelType', @level2type = N'COLUMN', @level2name = N'Units';

