CREATE VIEW [old].[vwMetaDataValueNum]
WITH SCHEMABINDING
AS
    SELECT
        [md].[MetadataID],
        [md].[Name],
        [md].[Value],
        [md].[IsLookUp],
        [md].[TopicTypeID],
        [md].[EntityName],
        [md].[EntityMemberName],
        [md].[DisplayOnly],
        [md].[TypeID],
        CASE ISNUMERIC([md].[Value])
            WHEN 1
                THEN CAST([md].[Value] AS DECIMAL(18, 6))
            ELSE
                NULL
        END AS [ValueNum]
    FROM
        [old].[Metadata] AS [md];