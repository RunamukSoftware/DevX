CREATE PROCEDURE [dbo].[usp_RemoveTrailingLiveWaveformData]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcedureName NVARCHAR(255) = OBJECT_NAME(@@PROCID);
    DECLARE @PurgeDate DATETIME = SYSDATETIME();
    DECLARE @StartDateTimeUTC DATETIME2 = SYSUTCDATETIME();
    DECLARE @Message VARCHAR(200) = '';
    DECLARE @ChunkSize INT = 1500;
    DECLARE @DateString VARCHAR(30) = CAST(SYSDATETIME() AS VARCHAR(30));
    DECLARE @Flag BIT = 1;
    DECLARE @TotalRows BIGINT = 0;
    DECLARE @RowCount BIGINT = 0;
    DECLARE @ErrorNumber INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000) = N'';
    DECLARE @Multiplier TINYINT = 100;

    SET @Message = CAST(SYSDATETIME() AS VARCHAR(30)) + ' - Starting WaveformLiveData purge...';
    RAISERROR(@Message, 10, 1)WITH NOWAIT;

    SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
    RAISERROR(N'%s - Chunk Size: %d', 10, 1, @DateString, @ChunkSize)WITH NOWAIT;

    --IF (OBJECT_ID(N'[tempdb]..[#CutoffRows]') IS NOT NULL)
    --    DROP TABLE [#CutoffRows];

    --CREATE TABLE [#CutoffRows]
    --    ([TopicInstanceId] UNIQUEIDENTIFIER NOT NULL,
    --     [TypeId] UNIQUEIDENTIFIER NOT NULL,
    --     [LatestUTC] DATETIME NOT NULL);

    --INSERT INTO [#CutoffRows] ([TopicInstanceId],
    --                           [TypeId],
    --                           [LatestUTC])
    --SELECT
    --    [wld].[TopicInstanceId],
    --    [wld].[TypeId],
    --    DATEADD(SECOND, -150, MAX([wld].[EndTimeUTC])) AS [LatestUTC]
    --FROM
    --    [dbo].[WaveformLiveData] AS [wld] WITH (SNAPSHOT)
    --GROUP BY
    --    [wld].[TopicInstanceId],
    --    [wld].[TypeId];

    WHILE (@Flag = 1)
    BEGIN
        BEGIN TRY
            --DELETE TOP (@ChunkSize)
            --    [wld]
            --FROM
            --    [dbo].[WaveformLiveData] AS [wld] WITH (SNAPSHOT) --WITH (ROWLOCK) -- Do not allow lock escalations.
            --    INNER JOIN [#CutoffRows] AS [cr]
            --        ON [wld].[TopicInstanceId] = [cr].[TopicInstanceId]
            --           AND [wld].[TypeId] = [cr].[TypeId]
            --WHERE
            --    [wld].[StartTimeUTC] < [cr].[LatestUTC];

            DELETE --TOP (@ChunkSize)
            [wld]
            FROM [dbo].[WaveformLiveData] AS [wld]
                INNER JOIN (SELECT --TOP (@ChunkSize)
                                [wld].[TopicInstanceId],
                                [wld].[TypeId],
                                DATEADD(SECOND, -150, MAX([wld].[EndTimeUTC])) AS [LatestUTC]
                            FROM [dbo].[WaveformLiveData] AS [wld]
                            GROUP BY [wld].[TopicInstanceId],
                                     [wld].[TypeId]) AS [TopicFeedLatestToKeep]
                    ON [wld].[TopicInstanceId] = [TopicFeedLatestToKeep].[TopicInstanceId]
            WHERE [wld].[StartTimeUTC] < [TopicFeedLatestToKeep].[LatestUTC];

            SET @RowCount = @@ROWCOUNT;
            SET @TotalRows += @RowCount;
        END TRY
        BEGIN CATCH
            SET @ErrorNumber = ERROR_NUMBER();
            SET @ErrorMessage = ERROR_MESSAGE();
            RAISERROR(N'%s - ERROR: %d : %s - CONTINUING...', 10, 1, @DateString, @ErrorNumber, @ErrorMessage)WITH NOWAIT;

            WAITFOR DELAY '00:00:01';

            CONTINUE;
        END CATCH;

        -- Report progress when Total Rows is a multiple of Chunk Size
        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0)
        BEGIN
            SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
            RAISERROR(N'%s - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows)WITH NOWAIT;
        END;

        IF (@RowCount = 0)
            SET @Flag = 0;
    END;

    EXEC [dbo].[uspInsertPurgerLog]
        @ProcedureName = @ProcedureName,
        @TableName = N'WaveformLiveData',
        @PurgeDate = @PurgeDate,
        @Parameters = '1st pass',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @DateString = CAST(SYSDATETIME() AS VARCHAR(30));
    RAISERROR(N'%s - Total Rows Deleted: %I64d', 10, 1, @DateString, @TotalRows)WITH NOWAIT;

    SET @Message = CAST(SYSDATETIME() AS VARCHAR(40)) + ' - Ending WaveformLiveData purge...';
    RAISERROR(@Message, 10, 1)WITH NOWAIT;
END;

GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Remove the waveform live data where start times are less than the latest end times per topic instance ID.',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'PROCEDURE',
    @level1name = N'usp_RemoveTrailingLiveWaveformData';

