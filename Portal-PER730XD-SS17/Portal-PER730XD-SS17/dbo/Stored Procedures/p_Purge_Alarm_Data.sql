CREATE PROCEDURE [dbo].[p_Purge_Alarm_Data]
    (
    @FChunkSize INT,
    @PurgeDate DATETIME,
    @AlarmsRowsPurged INT OUTPUT)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcedureName NVARCHAR(255) = OBJECT_NAME(@@PROCID);
    DECLARE @StartDateTimeUTC DATETIME2 = SYSUTCDATETIME();
    DECLARE @ChunkSize INT = @FChunkSize;
    DECLARE @DateString VARCHAR(30) = CAST(SYSDATETIME() AS VARCHAR(30));
    DECLARE @TotalRows BIGINT = 0;
    DECLARE @ErrorNumber INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000) = N'';
    DECLARE @Multiplier TINYINT = 10;
    DECLARE @Loop INT = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [ia]
        FROM [dbo].[int_alarm] AS [ia]
        WHERE [ia].[start_dt] < @PurgeDate;

        SET @Loop = @@ROWCOUNT;
        SET @TotalRows += @Loop;
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
        @TableName = N'int_alarm',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @AlarmsRowsPurged = @TotalRows;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Alarm_Data';

