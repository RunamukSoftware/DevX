CREATE TABLE [Intesys].[ChannelVital] (
    [ChannelVitalID]         INT           IDENTITY (1, 1) NOT NULL,
    [ChannelTypeID]          INT           NOT NULL,
    [GlobalDataSystemCodeID] INT           NOT NULL,
    [FormatString]           VARCHAR (50)  NOT NULL,
    [CreatedDateTime]        DATETIME2 (7) CONSTRAINT [DF_ChannelVital_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ChannelVital_ChannelVitalID] PRIMARY KEY CLUSTERED ([ChannelVitalID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ChannelVital_ChannelType_ChannelTypeID] FOREIGN KEY ([ChannelTypeID]) REFERENCES [Intesys].[ChannelType] ([ChannelTypeID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ChannelVital_ChannelTypeID_GlobalDataSystemCodeID]
    ON [Intesys].[ChannelVital]([ChannelTypeID] ASC, [GlobalDataSystemCodeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data about which vitals are displayed for a given channel. Each record represents one vital collected on the channel.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelVital';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Global Data System (GDS) code that is on a channel. Foreign key to the int_misc_code. The format is: <label>|{|$>|<S|M|L>|<B|R>|<L|C|R> #=direct replacement for a value $=has coding associated with it S= small size M=medium size L=large size B=Bold R=Regular L=Left align C=Center align R=Right align', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelVital', @level2type = N'COLUMN', @level2name = N'GlobalDataSystemCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'How to display a vital on a given channel.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ChannelVital', @level2type = N'COLUMN', @level2name = N'FormatString';

