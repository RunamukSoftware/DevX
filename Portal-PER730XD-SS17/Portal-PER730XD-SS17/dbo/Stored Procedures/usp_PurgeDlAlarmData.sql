
CREATE PROCEDURE [dbo].[usp_PurgeDlAlarmData]
    (
    @FChunkSize INT = 1500,
    @PurgeDateUTC DATETIME,
    @AlarmsRowsPurged INT OUTPUT)
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
        [gad]
        FROM [dbo].[GeneralAlarmsData] AS [gad] WITH (ROWLOCK) -- Do not allow lock escalations.
        WHERE [gad].[StartDateTime] < @PurgeDateUTC;

        SET @Loop = @@ROWCOUNT;
        SET @TotalRows += @Loop;

        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0) -- When Total Rows is a multiple of Chunk Size
        BEGIN
            SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
            RAISERROR(N'%s - [dbo].[GeneralAlarmsData] - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows)WITH NOWAIT;
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
        @TableName = N'GeneralAlarmsData',
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
        [lad]
        FROM [dbo].[LimitAlarmsData] AS [lad] WITH (ROWLOCK) -- Do not allow lock escalations.
        WHERE [lad].[StartDateTime] < @PurgeDateUTC;

        SET @Loop = @@ROWCOUNT;
        SET @TotalRows += @Loop;

        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0) -- When Total Rows is a multiple of Chunk Size
        BEGIN
            SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
            RAISERROR(N'%s - [dbo].[LimitAlarmsData] - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows)WITH NOWAIT;
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
        @TableName = N'LimitAlarmsData',
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
        [lcd]
        FROM [dbo].[LimitChangeData] AS [lcd] WITH (ROWLOCK) -- Do not allow lock escalations.
        WHERE [lcd].[AcquiredDateTimeUTC] < @PurgeDateUTC;

        SET @Loop = @@ROWCOUNT;
        SET @TotalRows += @Loop;

        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0) -- When Total Rows is a multiple of Chunk Size
        BEGIN
            SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
            RAISERROR(N'%s - [dbo].[LimitChangeData] - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows)WITH NOWAIT;
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
        @TableName = N'LimitChangeData',
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
        [asd]
        FROM [dbo].[AlarmsStatusData] AS [asd] WITH (ROWLOCK) -- Do not allow lock escalations.
        WHERE [asd].[AcquiredDateTimeUTC] < @PurgeDateUTC;

        SET @Loop = @@ROWCOUNT;
        SET @TotalRows += @Loop;

        IF (@TotalRows % (@ChunkSize * @Multiplier) = 0) -- When Total Rows is a multiple of Chunk Size
        BEGIN
            SET @DateString = CAST(SYSUTCDATETIME() AS VARCHAR(30));
            RAISERROR(N'%s - [dbo].[AlarmsStatusData] - Total Rows Deleted: %I64d ...', 10, 1, @DateString, @TotalRows)WITH NOWAIT;
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
        @TableName = N'AlarmsStatusData',
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
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Purge DL alarm data.',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'PROCEDURE',
    @level1name = N'usp_PurgeDlAlarmData';
