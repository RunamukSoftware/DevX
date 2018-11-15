CREATE VIEW [dbo].[vwMetaDataValueNum]
WITH
     SCHEMABINDING
AS
SELECT
    [md].[Id],
    [md].[Name],
    [md].[Value],
    [md].[IsLookUp],
    [md].[MetaDataId],
    [md].[TopicTypeId],
    [md].[EntityName],
    [md].[EntityMemberName],
    [md].[DisplayOnly],
    [md].[TypeId],
    CASE ISNUMERIC([md].[Value])
      WHEN 1 THEN CAST([md].[Value] AS DECIMAL(18, 6))
      ELSE NULL
    END AS [ValueNum]
FROM
    [dbo].[MetaData] AS [md];
