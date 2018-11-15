CREATE PROCEDURE [old].[uspRemoveTrailingLiveData]
    (
        @ChunkSize INT = 1500,
        @Debug     BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @Procedure NVARCHAR(128) = OBJECT_NAME(@@PROCID);
        DECLARE @PurgeDate DATETIME2(7) = SYSUTCDATETIME();
        DECLARE @DateString VARCHAR(30) = CAST(@PurgeDate AS VARCHAR(30));
        DECLARE @RowCount INT = @ChunkSize;
        DECLARE @TotalRows INT = 0;
        DECLARE @GrandTotal INT = 0;
        DECLARE @Message VARCHAR(200) = '';
        DECLARE @Flag BIT = 1;
        DECLARE @ErrorNumber INT = 0;
        DECLARE @ErrorMessage NVARCHAR(MAX);
        DECLARE @Multiple TINYINT = 100;
        DECLARE @StartDateTime DATETIME2(7) = SYSUTCDATETIME();

        IF (@Debug = 1)
            BEGIN
                SET @Message = CAST(SYSUTCDATETIME() AS VARCHAR(40)) + ' - Starting LiveData purge...';
                RAISERROR(@Message, 10, 1) WITH NOWAIT;

                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                RAISERROR(N'%s - Chunk Size: %d', 10, 1, @DateString, @ChunkSize) WITH NOWAIT;
            END;

        --IF (OBJECTID(N'tempdb..#CutoffRows') IS NOT NULL)
        --BEGIN
        --    DROP TABLE [#CutoffRows];
        --END;

        SELECT
            [ld].[TopicInstanceID],
            [ld].[FeedTypeID],
            DATEADD(SECOND, -150, MAX([ld].[Timestamp])) AS [Latest]
        INTO
            [#CutoffRows]
        FROM
            [old].[LiveData] AS [ld]
        GROUP BY
            [ld].[TopicInstanceID],
            [ld].[FeedTypeID];

        WHILE (@Flag = 1)
            BEGIN
                BEGIN TRY
                    DELETE TOP (@ChunkSize)
                    [ld]
                    FROM
                            [old].[LiveData] AS [ld] WITH (ROWLOCK) -- Do not allow lock escalations.
                        INNER JOIN
                            [#CutoffRows]    AS [TopicFeedLatestToKeep]
                                ON [ld].[TopicInstanceID] = [TopicFeedLatestToKeep].[TopicInstanceID]
                                   AND [ld].[FeedTypeID] = [TopicFeedLatestToKeep].[FeedTypeID]
                    WHERE
                            [ld].[Timestamp] < [TopicFeedLatestToKeep].[Latest];

                    --DELETE TOP (@ChunkSize)
                    --    [ld]
                    --FROM
                    --    [old].[LiveData] AS [ld] WITH (ROWLOCK) -- Do not allow lock escalations.
                    --    INNER JOIN (SELECT
                    --                    [ld2].[TopicInstanceID],
                    --                    [ld2].[FeedTypeID],
                    --                    DATEADD(SECOND, -150, MAX([ld2].[Timestamp])) AS [Latest]
                    --                FROM
                    --                    [old].[LiveData] AS [ld2]
                    --                GROUP BY
                    --                    [ld2].[TopicInstanceID],
                    --                    [ld2].[FeedTypeID]
                    --               ) AS [TopicFeedLatestToKeep]
                    --        ON [ld].[TopicInstanceID] = [TopicFeedLatestToKeep].[TopicInstanceID]
                    --           AND [ld].[FeedTypeID] = [TopicFeedLatestToKeep].[FeedTypeID]
                    --WHERE
                    --    [ld].[Timestamp] < [TopicFeedLatestToKeep].[Latest];

                    SET @RowCount = @@ROWCOUNT;
                    SET @TotalRows += @RowCount;
                END TRY
                BEGIN CATCH
                    SET @ErrorNumber = ERROR_NUMBER();
                    SET @ErrorMessage = ERROR_MESSAGE();
                    RAISERROR(N'%s - ERROR: %d - CONTINUING...', 10, 1, @DateString, @ErrorNumber) WITH NOWAIT;

                    CONTINUE;
                END CATCH;

                IF (@Debug = 1)
                    BEGIN
                        IF (@TotalRows % (@ChunkSize * @Multiple) = 0) -- When Total Rows is a multiple of Chunk Size
                            BEGIN
                                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                                RAISERROR(
                                             N'%s - Pass #1 - Total Rows Deleted: %I64d ...', 10, 1, @DateString,
                                             @TotalRows
                                         ) WITH NOWAIT;
                            END;
                    END;

                IF (@RowCount = 0)
                    SET @Flag = 0;
            END;

        IF (@Debug = 1)
            BEGIN
                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                RAISERROR(N'%s - Pass #1 - Total Rows Deleted: %I64d', 10, 1, @DateString, @TotalRows) WITH NOWAIT;

                SET @Message = CAST(SYSUTCDATETIME() AS VARCHAR(40)) + ' - Ending LiveData purge...';
                RAISERROR(@Message, 10, 1) WITH NOWAIT;
            END;

        EXEC [Purger].[uspInsertLog]
            @Procedure = @Procedure,
            @Table = N'LiveData',
            @PurgeDate = @PurgeDate,
            @Parameters = '1st pass',
            @ChunkSize = @ChunkSize,
            @Rows = @TotalRows,
            @ErrorNumber = @ErrorNumber,
            @ErrorMessage = @ErrorMessage,
            @StartDateTime = @StartDateTime;

        -- Delete any other live data older than 10 days
        SET @PurgeDate = DATEADD(DAY, -10, SYSUTCDATETIME());
        SET @RowCount = @ChunkSize;
        SET @GrandTotal += @TotalRows;
        SET @TotalRows = 0;
        SET @Flag = 1;
        SET @StartDateTime = SYSUTCDATETIME();

        WHILE (@Flag = 1)
            BEGIN
                BEGIN TRY
                    DELETE TOP (@ChunkSize) -- TOP is not allowed in an UPDATE or DELETE statement against a partitioned view.
                    [ld]
                    FROM
                        [old].[LiveData] AS [ld] WITH (ROWLOCK) -- Do not allow lock escalations.
                    WHERE
                        [ld].[Timestamp] < @PurgeDate;

                    SET @RowCount = @@ROWCOUNT;
                    SET @TotalRows += @RowCount;
                END TRY
                BEGIN CATCH
                    SET @ErrorNumber = ERROR_NUMBER();
                    SET @ErrorMessage = ERROR_MESSAGE();
                    RAISERROR(N'%s - ERROR: %d - CONTINUING...', 10, 1, @DateString, @ErrorNumber) WITH NOWAIT;

                    WAITFOR DELAY '00:00:01';

                    CONTINUE;
                END CATCH;

                IF (@Debug = 1)
                    BEGIN
                        IF (@TotalRows % (@ChunkSize * @Multiple) = 0) -- When Total Rows is a multiple of Chunk Size
                            BEGIN
                                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                                RAISERROR(
                                             N'%s - Pass #2 - Total Rows Deleted: %I64d ...', 10, 1, @DateString,
                                             @TotalRows
                                         ) WITH NOWAIT;
                            END;
                    END;

                IF (@RowCount = 0)
                    SET @Flag = 0;
            END;

        EXEC [Purger].[uspInsertLog]
            @Procedure = @Procedure,
            @Table = N'LiveData',
            @PurgeDate = @PurgeDate,
            @Parameters = '2nd pass',
            @ChunkSize = @ChunkSize,
            @Rows = @TotalRows,
            @ErrorNumber = @ErrorNumber,
            @ErrorMessage = @ErrorMessage,
            @StartDateTime = @StartDateTime;

        SET @GrandTotal += @TotalRows;

        IF (@Debug = 1)
            BEGIN
                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                RAISERROR(N'%s - Pass #2 - Total Rows Deleted: %I64d', 10, 1, @DateString, @TotalRows) WITH NOWAIT;

                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                RAISERROR(N'%s - Grand Total Rows Deleted: %I64d', 10, 1, @DateString, @GrandTotal) WITH NOWAIT;

                SET @Message = CAST(SYSUTCDATETIME() AS VARCHAR(40)) + ' - Ending LiveData purge...';
                RAISERROR(@Message, 10, 1) WITH NOWAIT;
            END;

        PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records (' + CAST(@GrandTotal AS NVARCHAR(20))
               + ') purged from ICS (' + @Procedure + ') at configured time interval : '
               + RTRIM(CONVERT(VARCHAR(30), @PurgeDate, 121)) + '.'
              );

        DROP TABLE [#CutoffRows];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Remove the live data attached to a topic instance that is over 2.5 minutes old.  Then delete any live data that is more than 10 days old.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRemoveTrailingLiveData';

