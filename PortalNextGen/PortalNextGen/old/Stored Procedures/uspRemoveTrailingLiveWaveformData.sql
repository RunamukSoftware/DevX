CREATE PROCEDURE [old].[uspRemoveTrailingLiveWaveformData]
    (
        @ChunkSize INT = 1500,
        @Debug     BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @Procedure NVARCHAR(128) = N'uspRemoveTrailingLiveWaveformData'; -- OBJECT_NAME(@@PROCID);
        DECLARE @PurgeDate DATETIME2(7) = SYSUTCDATETIME();
        DECLARE @Message VARCHAR(200) = '';
        DECLARE @DateString VARCHAR(30) = CAST(SYSUTCDATETIME() AS VARCHAR(30));
        DECLARE @Flag BIT = 1;
        DECLARE @TotalRows INT = 0;
        DECLARE @RowCount INT = 0;
        DECLARE @ErrorMessage NVARCHAR(MAX);
        DECLARE @ErrorNumber INT = 0;
        DECLARE @Multiplier TINYINT = 100;
        DECLARE @StartDateTime DATETIME2(7) = SYSUTCDATETIME();

        IF (@Debug = 1)
            BEGIN
                SET @Message = CAST(SYSUTCDATETIME() AS VARCHAR(30)) + ' - Starting WaveformLiveData purge...';
                RAISERROR(@Message, 10, 1) WITH NOWAIT;

                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                RAISERROR(N'%s - Chunk Size: %d', 10, 1, @DateString, @ChunkSize) WITH NOWAIT;
            END;

        SELECT
            [wld].[TopicInstanceID],
            [wld].[TypeID],
            MAX([wld].[EndDateTime]) AS [Latest]
        INTO
            [#CutoffRows]
        FROM
            [old].[WaveformLive] AS [wld]
        GROUP BY
            [wld].[TopicInstanceID],
            [wld].[TypeID];

        WHILE (@Flag = 1)
            BEGIN
                BEGIN TRY
                    DELETE TOP (@ChunkSize)
                    [wld]
                    FROM
                            [old].[WaveformLive] AS [wld] WITH (ROWLOCK) -- Do not allow lock escalations.
                        INNER JOIN
                            [#CutoffRows]        AS [cr]
                                ON [wld].[TopicInstanceID] = [cr].[TopicInstanceID]
                                   AND [wld].[TypeID] = [cr].[TypeID]
                    WHERE
                            [wld].[StartDateTime] < [cr].[Latest];

                    SET @RowCount = @@ROWCOUNT;
                    SET @TotalRows += @RowCount;
                END TRY
                BEGIN CATCH
                    SET @ErrorNumber = ERROR_NUMBER();
                    RAISERROR(N'%s - ERROR: %d - CONTINUING...', 10, 1, @DateString, @ErrorNumber) WITH NOWAIT;

                    WAITFOR DELAY '00:00:01';

                    CONTINUE;
                END CATCH;

                IF (@Debug = 1)
                    BEGIN
                        -- Report progress when Total Rows is a multiple of Chunk Size
                        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0)
                            BEGIN
                                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                                RAISERROR(N'%s - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows) WITH NOWAIT;
                            END;
                    END;

                IF (@RowCount = 0)
                    SET @Flag = 0;
            END;

        EXEC [Purger].[uspInsertLog]
            @Procedure = @Procedure,
            @Table = N'WaveformLiveData',
            @PurgeDate = @PurgeDate,
            @Parameters = '1st pass',
            @ChunkSize = @ChunkSize,
            @Rows = @TotalRows,
            @ErrorNumber = @ErrorNumber,
            @ErrorMessage = @ErrorMessage,
            @StartDateTime = @StartDateTime;

        IF (@Debug = 1)
            BEGIN
                SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
                RAISERROR(N'%s - Total Rows Deleted: %I64d', 10, 1, @DateString, @TotalRows) WITH NOWAIT;

                SET @Message = CAST(SYSUTCDATETIME() AS VARCHAR(40)) + ' - Ending WaveformLiveData purge...';
                RAISERROR(@Message, 10, 1) WITH NOWAIT;
            END;

        PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records (' + CAST(@TotalRows AS NVARCHAR(20))
               + ') purged from ICS (' + @Procedure + ') at configured time interval : '
               + RTRIM(CONVERT(VARCHAR(30), @PurgeDate, 121)) + '.'
              );

        DROP TABLE [#CutoffRows];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Remove the waveform live data where start times are less than the latest end times per topic instance ID.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRemoveTrailingLiveWaveformData';

