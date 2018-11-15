CREATE PROCEDURE [dbo].[p_Purge_Result_Data]
    (
    @FChunkSize INT,
    @PurgeDate DATETIME,
    @HL7MonitorRowsPurged INT OUTPUT)
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
    --DECLARE @Multiplier TINYINT = 10;
    DECLARE @Loop INT = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [ir]
        FROM [dbo].[int_result] AS [ir]
        WHERE [ir].[obs_start_dt] < @PurgeDate;

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
        @TableName = N'int_result',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @TotalRows = 0;
    SET @Loop = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [iol]
        FROM [dbo].[int_order_line] AS [iol]
            INNER JOIN [dbo].[int_order] AS [io]
                ON [iol].[order_id] = [io].[order_id]
        WHERE [io].[order_dt] < @PurgeDate;

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
        @TableName = N'int_order_line',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @TotalRows = 0;
    SET @Loop = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [iom]
        FROM [dbo].[int_order_map] AS [iom]
            INNER JOIN [dbo].[int_order] AS [io]
                ON [iom].[order_id] = [io].[order_id]
        WHERE [io].[order_dt] < @PurgeDate;

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
        @TableName = N'int_order_map',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @TotalRows = 0;
    SET @Loop = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [io]
        FROM [dbo].[int_order] AS [io]
        WHERE [io].[order_dt] < @PurgeDate;

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
        @TableName = N'int_order',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @HL7MonitorRowsPurged = @TotalRows;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge old int_results data.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Result_Data';
