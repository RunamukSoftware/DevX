CREATE PROCEDURE [dbo].[usp_RemoveTrailingLiveData]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcedureName NVARCHAR(255) = OBJECT_NAME(@@PROCID);
    DECLARE @PurgeDate DATETIME = SYSDATETIME();
    DECLARE @StartDateTimeUTC DATETIME2 = SYSUTCDATETIME();
    DECLARE @ChunkSize INT = 1500;
    DECLARE @DateString VARCHAR(30) = CAST(SYSDATETIME() AS VARCHAR(30));
    DECLARE @RowCount BIGINT = @ChunkSize;
    DECLARE @TotalRows BIGINT = 0;
    DECLARE @Message VARCHAR(200) = '';
    DECLARE @Flag BIT = 1;
    DECLARE @ErrorNumber INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000) = N'';
    DECLARE @Multiplier TINYINT = 100;

    SET @Message = CAST(SYSDATETIME() AS VARCHAR(40)) + ' - Starting LiveData purge...';
    RAISERROR (@Message, 10, 1) WITH NOWAIT;

    SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
    RAISERROR (N'%s - Chunk Size: %d', 10, 1, @DateString, @ChunkSize) WITH NOWAIT;
    
    --IF (OBJECT_ID(N'[tempdb]..[#CutoffRows]') IS NOT NULL)
    --    DROP TABLE [#CutoffRows];

    --CREATE TABLE [#CutoffRows]
    --    ([TopicInstanceId] UNIQUEIDENTIFIER NOT NULL,
    --     [FeedTypeId] UNIQUEIDENTIFIER NOT NULL,
    --     [LatestUTC] DATETIME NOT NULL);

    --INSERT INTO [#CutoffRows] ([TopicInstanceId],
    --                           [FeedTypeId],
    --                           [LatestUTC])
    --SELECT
    --    [TopicInstanceId],
    --    [FeedTypeId],
    --    DATEADD(SECOND, -150, MAX([TimestampUTC])) AS [LatestUTC]
    --FROM
    --    [dbo].[LiveData] AS [ld] WITH (SNAPSHOT)
    --GROUP BY
    --    [TopicInstanceId],
    --    [FeedTypeId];

    WHILE (@Flag = 1)
    BEGIN
        BEGIN TRY
            --DELETE TOP (@ChunkSize) [ld]
            --FROM
            --    [dbo].[LiveData] AS [ld] WITH (SNAPSHOT) --WITH (ROWLOCK) -- Do not allow lock escalations.
            --    INNER JOIN [#CutoffRows] AS [cr]
            --    ON [ld].[TopicInstanceId] = [cr].[TopicInstanceId]
            --        AND [ld].[FeedTypeId] = [cr].[FeedTypeId]
            --WHERE
            --    [ld].[TimestampUTC] < [cr].[LatestUTC];

            DELETE --TOP (1500)
            [ld]
            FROM [dbo].[LiveData] AS [ld] --WITH (ROWLOCK) -- Do not allow lock escalations.
                INNER JOIN (SELECT --TOP (1500)
                                [ld2].[TopicInstanceId],
                                [ld2].[FeedTypeId],
                                DATEADD(SECOND, -150, MAX([ld2].[TimestampUTC])) AS [LatestUTC]
                            FROM [dbo].[LiveData] AS [ld2] --WITH (SNAPSHOT) --WITH (ROWLOCK) -- Do not allow lock escalations.
                            GROUP BY [ld2].[TopicInstanceId],
                                     [ld2].[FeedTypeId]) AS [TopicFeedLatestToKeep]
                    ON [ld].[TopicInstanceId] = [TopicFeedLatestToKeep].[TopicInstanceId]
                       AND [ld].[FeedTypeId] = [TopicFeedLatestToKeep].[FeedTypeId]
            WHERE [ld].[TimestampUTC] < [TopicFeedLatestToKeep].[LatestUTC];

            SET @RowCount = @@ROWCOUNT;
            SET @TotalRows += @RowCount;
        END TRY
        BEGIN CATCH
            SET @ErrorNumber = ERROR_NUMBER();
            SET @ErrorMessage = ERROR_MESSAGE();
            RAISERROR (N'%s - ERROR: %d : %s - CONTINUING...', 10, 1, @DateString, @ErrorNumber, @ErrorMessage) WITH NOWAIT;

            WAITFOR DELAY '00:00:01';
    
            CONTINUE;
        END CATCH;

        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0) -- When Total Rows is a multiple of Chunk Size
        BEGIN
            SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
            RAISERROR (N'%s - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows) WITH NOWAIT;
        END;

        IF (@RowCount = 0)
            SET @Flag = 0;
    END;

    EXEC [dbo].[uspInsertPurgerLog]
        @ProcedureName = @ProcedureName,
        @TableName = N'LiveData',
        @PurgeDate = @PurgeDate,
        @Parameters = '1st pass',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    -- Delete any other live data older than 10 days
    SET @PurgeDate = DATEADD(DAY, -10, SYSUTCDATETIME());
    SET @RowCount = @ChunkSize;
    SET @Flag = 1;

    WHILE (@Flag = 1)
    BEGIN
        BEGIN TRY
            DELETE TOP (@ChunkSize) -- TOP is not allowed in an UPDATE or DELETE statement against a partitioned view.
                [ld]
            FROM
                [dbo].[LiveData] AS [ld] WITH (SNAPSHOT) --WITH (ROWLOCK) -- Do not allow lock escalations.
            WHERE
                [ld].[TimestampUTC] < @PurgeDate;

            SET @RowCount = @@ROWCOUNT;
            SET @TotalRows += @RowCount;
        END TRY
        BEGIN CATCH
            SET @ErrorNumber = ERROR_NUMBER();
            SET @ErrorMessage = ERROR_MESSAGE();
            RAISERROR (N'%s - ERROR: %d : %s - CONTINUING...', 10, 1, @DateString, @ErrorNumber, @ErrorMessage) WITH NOWAIT;

            WAITFOR DELAY '00:00:01';
    
            CONTINUE;
        END CATCH;

        SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
        RAISERROR (N'%s - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows) WITH NOWAIT;

        IF (@RowCount = 0)
            SET @Flag = 0;
    END;

    EXEC [dbo].[uspInsertPurgerLog]
        @ProcedureName = @ProcedureName,
        @TableName = N'LiveData',
        @PurgeDate = @PurgeDate,
        @Parameters = '2nd pass > 10 days',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
    RAISERROR (N'%s - Total Rows Deleted: %I64d', 10, 1, @DateString, @TotalRows) WITH NOWAIT;

    SET @Message = CAST(SYSDATETIME() AS VARCHAR(40)) + ' - Ending LiveData purge...';
    RAISERROR (@Message, 10, 1) WITH NOWAIT;
END;

GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Remove the live data attached to a topic instance that is over 2.5 minutes old.  Then delete any live data that is more than 10 days old.',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'PROCEDURE',
    @level1name = N'usp_RemoveTrailingLiveData';

