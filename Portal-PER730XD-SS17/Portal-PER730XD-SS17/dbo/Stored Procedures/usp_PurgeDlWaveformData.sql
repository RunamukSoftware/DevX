CREATE PROCEDURE [dbo].[usp_PurgeDlWaveformData]
    (
    @FChunkSize INT,
    @PurgeDateUTC DATETIME,
    @WaveformDataPurged INT OUTPUT)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcedureName NVARCHAR(255) = OBJECT_NAME(@@PROCID);
    DECLARE @PurgeDate DATETIME = SYSDATETIME();
    DECLARE @StartDateTimeUTC DATETIME2 = SYSUTCDATETIME();
    DECLARE @ChunkSize INT = 1500;
    DECLARE @DateString VARCHAR(30) = CAST(SYSDATETIME() AS VARCHAR(30));
    DECLARE @TotalRows BIGINT = 0;
    DECLARE @ErrorNumber INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000) = N'';
    DECLARE @Multiplier TINYINT = 10;
    DECLARE @Loop INT = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [wd]
        FROM [dbo].[WaveformData] AS [wd] WITH (ROWLOCK) -- Do not allow lock escalations.
        WHERE [wd].[StartTimeUTC] < @PurgeDateUTC;

        SET @Loop = @@ROWCOUNT;
        SET @TotalRows += @Loop;

        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0) -- When Total Rows is a multiple of Chunk Size
        BEGIN
            SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
            RAISERROR(
                N'%s - [dbo].[WaveformData] - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows) WITH NOWAIT;
        END;
    END TRY
    BEGIN CATCH
        SET @ErrorNumber = ERROR_NUMBER();
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'%s - ERROR: %d : %s - CONTINUING...', 10, 1, @DateString, @ErrorNumber, @ErrorMessage)WITH NOWAIT;

        WAITFOR DELAY '00:00:01';

        CONTINUE;
    END CATCH;

    EXEC [dbo].[uspInsertPurgerLog]
        @ProcedureName = @ProcedureName,
        @TableName = N'WaveformData',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @WaveformDataPurged = @TotalRows;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge DL waveform data.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PurgeDlWaveformData';
