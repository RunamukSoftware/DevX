CREATE VIEW [dbo].[v_LegacyChannelTypes]
WITH
     SCHEMABINDING
AS
SELECT
    ISNULL([MDMax].[TypeId], [tt].[Id]) AS [ChannelTypeId],
    [tt].[Id] AS [TopicTypeId],
    [tt].[Name] AS [TopicName],
    [MDLabel].[Value] AS [CdiLabel],
    [MDMax].[PairEntityName] AS [TypeName],
    [MDMax].[TypeId],
    --MDMax.PairValue AS 'MaxValue', --MaxValue in SalishMetadata is 4095 coming from ushort exactly as received from the monitor, which is different from what ICS needs
    --MDMin.PairValue AS 'MinValue', --MinValue in SalishMetadata is 0-based, which is coming from ushort exactly as received from the monitor, which is different from what ICS needs
    [MDSampleRate].[PairValue] AS [SampleRate],
    [MDChannelCode].[Value] AS [ChannelCode],
    [ict].[label]
FROM
    [dbo].[TopicTypes] AS [tt]
    INNER JOIN (SELECT
                    [meta].[Value],
                    [meta].[TopicTypeId],
                    [meta].[Name],
                    [meta].[EntityName],
                    [meta].[TypeId]
                FROM
                    [dbo].[v_MetaData] AS [meta]
                WHERE
                    [meta].[Name] = 'ChannelCode'
               ) AS [MDChannelCode] ON [MDChannelCode].[TopicTypeId] = [tt].[Id]
    LEFT OUTER JOIN (SELECT
                        [Value],
                        [TypeId]
                     FROM
                        [dbo].[v_MetaData]
                     WHERE
                        [Name] = 'Label'
                    ) AS [MDLabel] ON [MDLabel].[TypeId] = [MDChannelCode].[TypeId]
    LEFT OUTER JOIN (SELECT
                        [PairValue],
                        [TopicTypeId],
                        [PairName],
                        [PairEntityName],
                        [PairEntityMember],
                        [PairMetaDataId],
                        [EntityName],
                        [TypeId]
                     FROM
                        [dbo].[v_MetaData]
                     WHERE
                        ([PairName] = 'ScaledMax')
                        AND [DisplayOnly] = '0'
                    ) AS [MDMax] ON [MDLabel].[TypeId] = [MDMax].[TypeId]
    LEFT OUTER JOIN (SELECT
                        [meta].[PairValue],
                        [meta].[PairMetaDataId]
                     FROM
                        [dbo].[v_MetaData] AS [meta]
                     WHERE
                        [meta].[PairName] = 'ScaledMin'
                    ) AS [MDMin] ON [MDMin].[PairMetaDataId] = [MDMax].[PairMetaDataId]
    LEFT OUTER JOIN (SELECT
                        [meta].[PairValue],
                        [meta].[PairMetaDataId]
                     FROM
                        [dbo].[v_MetaData] AS [meta]
                     WHERE
                        [meta].[PairName] = 'SampleRate'
                    ) AS [MDSampleRate] ON [MDSampleRate].[PairMetaDataId] = [MDMax].[PairMetaDataId]
    LEFT OUTER JOIN [dbo].[int_channel_type] AS [ict] ON [ict].[channel_code] = CAST([MDChannelCode].[Value] AS INT);

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LegacyChannelTypes';

