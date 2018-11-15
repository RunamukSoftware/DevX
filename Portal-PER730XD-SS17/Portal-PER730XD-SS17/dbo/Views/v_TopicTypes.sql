CREATE VIEW [dbo].[v_TopicTypes]
AS
SELECT
    [tt].[Id],
    [tt].[Name],
    [tt].[BaseId],
    [tt].[Comment],
    [MDLabel].[Value] AS [Label]
FROM
    [dbo].[TopicTypes] AS [tt]
    LEFT OUTER JOIN (SELECT
                        [md].[Value],
                        [md].[TopicTypeId],
                        [md].[Name]
                     FROM
                        [dbo].[MetaData] AS [md]
                     WHERE
                        [md].[Name] = 'Label'
                        AND [md].[EntityName] IS NULL
                    ) AS [MDLabel] ON [MDLabel].[TopicTypeId] = [tt].[Id];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_TopicTypes';

