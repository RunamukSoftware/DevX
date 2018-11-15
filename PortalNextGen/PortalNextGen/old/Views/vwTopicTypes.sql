CREATE VIEW [old].[vwTopicTypes]
AS
    SELECT
        [tt].[TopicTypeID],
        [tt].[Name],
        [tt].[BaseID],
        [tt].[Comment],
        [MDLabel].[Value] AS [Label]
    FROM
        [old].[TopicType] AS [tt]
        LEFT OUTER JOIN
            (
                SELECT
                    [md].[Value],
                    [md].[TopicTypeID],
                    [md].[Name]
                FROM
                    [old].[Metadata] AS [md]
                WHERE
                    [md].[Name] = 'Label'
                    AND [md].[EntityName] IS NULL
            )             AS [MDLabel]
                ON [MDLabel].[TopicTypeID] = [tt].[TopicTypeID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwTopicTypes';

