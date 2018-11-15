CREATE TABLE [dbo].[int_channel_vital] (
    [channel_type_id] UNIQUEIDENTIFIER NOT NULL,
    [gds_cid]         INT              NOT NULL,
    [format_string]   VARCHAR (50)     NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_channel_vital_channel_type_id_gds_cid]
    ON [dbo].[int_channel_vital]([channel_type_id] ASC, [gds_cid] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data about which vitals are displayed for a given channel. Each record represents one vital collected on the channel.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_vital';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The GDS code that is on a channel. Foreign key to the int_misc_code. The format is: <label>|{|$>|<S|M|L>|<B|R>|<L|C|R> #=direct replacement for a value $=has coding associated with it S= small size M=medium size L=large size B=Bold R=Regular L=Left align C=Center align R=Right align', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_vital', @level2type = N'COLUMN', @level2name = N'gds_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'How to display a vital on a given channel.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_channel_vital', @level2type = N'COLUMN', @level2name = N'format_string';

