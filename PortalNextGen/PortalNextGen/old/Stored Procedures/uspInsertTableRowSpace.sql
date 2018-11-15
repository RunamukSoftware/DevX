CREATE PROCEDURE [old].[uspInsertTableRowSpace]
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[TableRowSpace]
            (
                [DatabaseName],
                [SchemaName],
                [TableName],
                [IndexID],
                [IndexName],
                [RowCount],
                [TotalSpaceKB],
                [UsedSpaceKB],
                [UnusedSpaceKB]
            )
                    SELECT
                        DB_NAME()                                            AS [DatabaseName],
                        [s].[name]                                           AS [SchemaName],
                        [t].[name]                                           AS [TableName],
                        [i].[index_id]                                       AS [IndexID],
                        [i].[name]                                           AS [IndexName],
                        [p].[rows]                                           AS [RowCount],
                        SUM([a].[total_pages]) * 8                           AS [TotalSpaceKB],
                        SUM([a].[used_pages]) * 8                            AS [UsedSpaceKB],
                        (SUM([a].[total_pages]) - SUM([a].[used_pages])) * 8 AS [UnusedSpaceKB]
                    FROM
                        [sys].[tables]               AS [t]
                        INNER JOIN
                            [sys].[schemas]          AS [s]
                                ON [s].[schema_id] = [t].[schema_id]
                        INNER JOIN
                            [sys].[indexes]          AS [i]
                                ON [t].[object_id] = [i].[object_id]
                        INNER JOIN
                            [sys].[partitions]       AS [p]
                                ON [i].[object_id] = [p].[object_id]
                                   AND [i].[index_id] = [p].[index_id]
                        INNER JOIN
                            [sys].[allocation_units] AS [a]
                                ON [p].[partition_id] = [a].[container_id]
                    WHERE
                        [t].[name] NOT LIKE N'dt%' -- filter out system tables for diagramming
                        AND [t].[is_ms_shipped] = 0
                        AND [i].[object_id] > 255
                    GROUP BY
                        [t].[name],
                        [s].[name],
                        [i].[index_id],
                        [i].[name],
                        [p].[rows]
                    ORDER BY
                        [s].[name],
                        [t].[name],
                        [i].[name];
    END;