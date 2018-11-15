CREATE VIEW [dbo].[v_MetaData]
WITH
     SCHEMABINDING
AS
SELECT
    [meta].[Id],
    [meta].[Name],
    [meta].[Value],
    [meta].[TypeId],
    [meta].[IsLookUp],
    [meta].[TopicTypeId],
    [meta].[EntityName],
    [meta].[EntityMemberName],
    [meta].[DisplayOnly],
    [metaPairs].[Name] AS [PairName],
    [metaPairs].[Value] AS [PairValue],
    [metaPairs].[IsLookUp] AS [PairLookup],
    [metaPairs].[EntityName] AS [PairEntityName],
    [metaPairs].[EntityMemberName] AS [PairEntityMember],
    [metaPairs].[MetaDataId] AS [PairMetaDataId]
FROM
    [dbo].[MetaData] AS [meta]
    LEFT OUTER JOIN [dbo].[MetaData] AS [metaPairs] ON [metaPairs].[MetaDataId] = [meta].[Id]
WHERE
    [meta].[MetaDataId] IS NULL;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_MetaData';

