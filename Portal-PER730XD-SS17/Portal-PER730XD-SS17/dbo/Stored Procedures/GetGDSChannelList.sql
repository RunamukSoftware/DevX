CREATE PROCEDURE [dbo].[GetGDSChannelList]
AS
BEGIN
    SELECT
        [ch].[channel_type_id] AS [CHANNEL_TYPE_ID],
        [channel_code] AS [CODE],
        [label] AS [LABEL],
        [freq] AS [FREQUENCY],
        [min_value] AS [MIN_VALUE],
        [max_value] AS [MAX_VALUE],
        [sweep_speed] AS [SWEEP_SPEED],
        [priority] AS [priority],
        [type_cd] AS [TYPE_CD],
        [color] AS [COLOR],
        [units] AS [UNITS],
        [short_dsc] AS [SHORT_DESCRIPTION],
        [format_string] AS [FORMAT_STRING]
    FROM
        [dbo].[int_channel_type] AS [ch]
        INNER JOIN [dbo].[int_misc_code] AS [mc] ON [ch].[gds_cid] = [mc].[code_id]
        INNER JOIN [dbo].[int_channel_vital] AS [chv] ON [ch].[channel_type_id] = [chv].[channel_type_id]
    UNION ALL
    SELECT
        [vlct].[ChannelTypeId] AS [CHANNEL_TYPE_ID],
        [vlct].[ChannelCode] AS [CODE],
        [vlct].[label] AS [LABEL],
        [vlct].[SampleRate] AS [FREQUENCY],
        [ch].[min_value] AS [MIN_VALUE],
        [ch].[max_value] AS [MAX_VALUE],
        [ch].[sweep_speed] AS [SWEEP_SPEED],
        [ch].[priority] AS [priority],
        [ch].[type_cd] AS [TYPE_CD],
        [ch].[color] AS [COLOR],
        [ch].[units] AS [UNITS],
        NULL AS [SHORT_DESCRIPTION],
        [format_string] AS [FORMAT_STRING]
    FROM
        [dbo].[v_LegacyChannelTypes] AS [vlct]
        LEFT OUTER JOIN [dbo].[int_channel_type] AS [ch] ON [ch].[channel_code] = [vlct].[ChannelCode]
        INNER JOIN [dbo].[int_channel_vital] AS [chv] ON [ch].[channel_type_id] = [chv].[channel_type_id]
    ORDER BY
        [CHANNEL_TYPE_ID],
        [FORMAT_STRING];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetGDSChannelList';

