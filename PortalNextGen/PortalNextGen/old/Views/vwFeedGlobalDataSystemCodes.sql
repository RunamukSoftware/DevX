CREATE VIEW [old].[vwFeedGlobalDataSystemCodes]
AS
    SELECT DISTINCT
        [vm].[TypeID] AS [FeedTypeID],
        [vm].[Value]  AS [GlobalDataSystemCode]
    FROM
        [old].[vwMetadata] AS [vm]
    WHERE
        [vm].[Name] = 'GdsCode';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwFeedGlobalDataSystemCodes';

