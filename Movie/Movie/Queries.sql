USE [Movie];
GO

-- DVDs and Actors
SELECT
    [d].*,
    [ad].*,
    [a].*
FROM [dbo].[Dvd] AS [d]
    INNER JOIN [dbo].[ActorDvd] AS [ad]
        ON [d].[DvdID] = [ad].[DvdID]
    INNER JOIN [dbo].[Actor] AS [a]
        ON [ad].[ActorID] = [a].[ActorID]
WHERE [d].[DVD_Title] LIKE N'Big Bang Theory%'
ORDER BY [d].[DVD_Title],
         [a].[Name];

-- DVDs and Directors
SELECT
    [d].*,
    [dd].*,
    [di].*
FROM [dbo].[Dvd] AS [d]
    INNER JOIN [dbo].[DirectorDvd] AS [dd]
        ON [d].[DvdID] = [dd].[DvdID]
    INNER JOIN [dbo].[Director] AS [di]
        ON [dd].[DirectorID] = [di].[DirectorID]
ORDER BY [d].[DVD_Title],
         [di].[Name];
GO


-- Duplicate Actor -> Dvd
SELECT
    [ad].[ActorID],
    [ad].[DvdID],
    COUNT(*) AS [RowCount]
FROM [dbo].[ActorDvd] AS [ad]
GROUP BY [ad].[ActorID],
         [ad].[DvdID]
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

WITH [CTE]
AS (SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY
                               [ad].[ActorID],
                               [ad].[DvdID]
                           ORDER BY [ad].[ActorID],
                                    [ad].[DvdID]) AS [RowNumber]
    FROM [dbo].[ActorDvd] AS [ad])
SELECT [CTE].[RowNumber]
FROM [CTE]
WHERE [CTE].[RowNumber] > 1;
--DELETE FROM [CTE] WHERE [CTE].[RN] <> 1;
GO


-- Duplicate Director -> Dvd
SELECT
    [dd].[DirectorID],
    [dd].[DvdID],
    COUNT(*) AS [RowCount]
FROM [dbo].[DirectorDvd] AS [dd]
GROUP BY [dd].[DirectorID],
         [dd].[DvdID]
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

WITH [CTE]
AS (SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY
                               [dd].[DirectorID],
                               [dd].[DvdID]
                           ORDER BY [dd].[DirectorID],
                                    [dd].[DvdID]) AS [RowNumber]
    FROM [dbo].[DirectorDvd] AS [dd])
SELECT [CTE].[RowNumber]
FROM [CTE]
WHERE [CTE].[RowNumber] > 1;
--DELETE FROM [CTE] WHERE [CTE].[RN] <> 1;
GO
