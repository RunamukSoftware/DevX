CREATE PROCEDURE [old].[GetGlobalDataSystemChannelList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ch].[ChannelTypeID],
            [ch].[ChannelCode],
            [ch].[Label],
            [ch].[Frequency],
            [ch].[MinimumValue],
            [ch].[MaximumValue],
            [ch].[SweepSpeed],
            [ch].[Priority],
            [ch].[TypeCode],
            [ch].[Color],
            [ch].[Units],
            [mc].[ShortDescription],
            [chv].[FormatString]
        FROM
            [Intesys].[ChannelType]           AS [ch]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [mc]
                    ON [ch].[GlobalDataSystemCodeID] = [mc].[CodeID]
            INNER JOIN
                [Intesys].[ChannelVital]      AS [chv]
                    ON [ch].[ChannelTypeID] = [chv].[ChannelTypeID]
        UNION ALL
        SELECT
            [vlct].[ChannelTypeID] AS [CHANNEL_TYPEID],
            [vlct].[ChannelCode]   AS [CODE],
            [vlct].[Label]         AS [LABEL],
            [vlct].[SampleRate]    AS [FREQUENCY],
            [ch].[MinimumValue]    AS [MIN_VALUE],
            [ch].[MaximumValue]    AS [MAX_VALUE],
            [ch].[SweepSpeed]      AS [SweepSpeed],
            [ch].[Priority]        AS [priority],
            [ch].[TypeCode]        AS [TypeCode],
            [ch].[Color]           AS [COLOR],
            [ch].[Units]           AS [UNITS],
            NULL                   AS [SHORT_DESCRIPTION],
            [chv].[FormatString]   AS [FORMAT_STRING]
        FROM
            [old].[vwLegacyChannelTypes] AS [vlct]
            LEFT OUTER JOIN
                [Intesys].[ChannelType]  AS [ch]
                    ON [ch].[ChannelCode] = [vlct].[ChannelCode]
            INNER JOIN
                [Intesys].[ChannelVital] AS [chv]
                    ON [ch].[ChannelTypeID] = [chv].[ChannelTypeID]
        ORDER BY
            [ChannelTypeID],
            [chv].[FormatString];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'GetGlobalDataSystemChannelList';

