CREATE VIEW [old].[vwMetadata]
WITH SCHEMABINDING
AS
    SELECT
        [m1].[MetadataID],
        [m1].[Name],
        [m1].[Value],
        [m1].[TypeID],
        [m1].[IsLookUp],
        [m1].[TopicTypeID],
        [m1].[EntityName],
        [m1].[EntityMemberName],
        [m1].[DisplayOnly],
        [m2].[Name]             AS [PairName],
        [m2].[Value]            AS [PairValue],
        [m2].[IsLookUp]         AS [PairLookup],
        [m2].[EntityName]       AS [PairEntityName],
        [m2].[EntityMemberName] AS [PairEntityMember],
        [m2].[MetadataID]       AS [PairMetaDataID]
    FROM
        [old].[Metadata]     AS [m1]
        LEFT OUTER JOIN
            [old].[Metadata] AS [m2]
                ON [m1].[MetadataID] = [m2].[MetadataID]
    WHERE
        [m1].[MetadataID] IS NULL;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwMetadata';

