CREATE VIEW [old].[vwLegacyChannelTypes]
WITH SCHEMABINDING
AS
    SELECT
        ISNULL([MDMax].[TypeID], [tt].[TopicTypeID]) AS [ChannelTypeID],
        [tt].[TopicTypeID]                           AS [TopicTypeID],
        [tt].[Name]                                  AS [TopicName],
        [MDLabel].[Value]                            AS [CdiLabel],
        [MDMax].[PairEntityName]                     AS [TypeName],
        [MDMax].[TypeID],
        --MDMax.PairValue AS 'MaxValue', --MaxValue in SalishMetadata is 4095 coming from ushort exactly as received from the monitor, which is different from what ICS needs
        --MDMin.PairValue AS 'MinValue', --MinValue in SalishMetadata is 0-based, which is coming from ushort exactly as received from the monitor, which is different from what ICS needs
        [MDSampleRate].[PairValue]                   AS [SampleRate],
        [MDChannelCode].[Value]                      AS [ChannelCode],
        [ict].[Label]
    FROM
        [old].[TopicType]           AS [tt]
        INNER JOIN
            (
                SELECT
                    [m1].[Value],
                    [m1].[TopicTypeID],
                    [m1].[Name],
                    [m1].[EntityName],
                    [m1].[TypeID]
                FROM
                    [old].[vwMetadata] AS [m1]
                WHERE
                    [m1].[Name] = 'ChannelCode'
            )                       AS [MDChannelCode]
                ON [MDChannelCode].[TopicTypeID] = [tt].[TopicTypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [m2].[Value],
                    [m2].[TypeID]
                FROM
                    [old].[vwMetadata] AS [m2]
                WHERE
                    [m2].[Name] = 'Label'
            )                       AS [MDLabel]
                ON [MDLabel].[TypeID] = [MDChannelCode].[TypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [m3].[PairValue],
                    [m3].[TopicTypeID],
                    [m3].[PairName],
                    [m3].[PairEntityName],
                    [m3].[PairEntityMember],
                    [m3].[PairMetaDataID],
                    [m3].[EntityName],
                    [m3].[TypeID]
                FROM
                    [old].[vwMetadata] AS [m3]
                WHERE
                    [m3].[PairName] = 'ScaledMax'
                    AND [m3].[DisplayOnly] = '0'
            )                       AS [MDMax]
                ON [MDLabel].[TypeID] = [MDMax].[TypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [m4].[PairValue],
                    [m4].[PairMetaDataID]
                FROM
                    [old].[vwMetadata] AS [m4]
                WHERE
                    [m4].[PairName] = 'ScaledMin'
            )                       AS [MDMin]
                ON [MDMin].[PairMetaDataID] = [MDMax].[PairMetaDataID]
        LEFT OUTER JOIN
            (
                SELECT
                    [m5].[PairValue],
                    [m5].[PairMetaDataID]
                FROM
                    [old].[vwMetadata] AS [m5]
                WHERE
                    [m5].[PairName] = 'SampleRate'
            )                       AS [MDSampleRate]
                ON [MDSampleRate].[PairMetaDataID] = [MDMax].[PairMetaDataID]
        LEFT OUTER JOIN
            [Intesys].[ChannelType] AS [ict]
                ON [ict].[ChannelCode] = CAST([MDChannelCode].[Value] AS INT);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLegacyChannelTypes';

