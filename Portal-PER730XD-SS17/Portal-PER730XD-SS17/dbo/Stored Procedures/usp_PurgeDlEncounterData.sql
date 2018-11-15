CREATE PROCEDURE [dbo].[usp_PurgeDlEncounterData]
    (
    @FChunkSize INT,
    @EncounterDataPurged INT OUTPUT)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PurgeDateTimeUTC DATETIME = DATEADD(DAY, -10, GETUTCDATE());
    DECLARE @ProcedureName NVARCHAR(255) = OBJECT_NAME(@@PROCID);
    --DECLARE @PurgeDate DATETIME = SYSDATETIME();
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
        [ds]
        FROM [dbo].[DeviceSessions] AS [ds]
        WHERE [ds].[EndTimeUTC] IS NOT NULL
              AND [ds].[EndTimeUTC] <= @PurgeDateTimeUTC;

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
        @TableName = N'DeviceSessions',
        @PurgeDate = @PurgeDateTimeUTC,
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
        [did]
        FROM [dbo].[DeviceInfoData] AS [did]
            LEFT OUTER JOIN [dbo].[DeviceSessions] AS [ds]
                ON [did].[DeviceSessionId] = [ds].[Id]
        WHERE [ds].[Id] IS NULL;

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
        @TableName = N'DeviceSessions',
        @PurgeDate = @PurgeDateTimeUTC,
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
        FROM [dbo].[TopicSessions]
        WHERE [EndTimeUTC] IS NOT NULL
              AND [EndTimeUTC] <= @PurgeDateTimeUTC;

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
        @TableName = N'TopicSessions',
        @PurgeDate = @PurgeDateTimeUTC,
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
        FROM [dbo].[PatientData]
        WHERE [PatientSessionId] IN (SELECT [ps].[Id]
                                     FROM [dbo].[PatientSessions] AS [ps]
                                     WHERE [ps].[EndTimeUTC] IS NOT NULL
                                           AND [ps].[EndTimeUTC] <= @PurgeDateTimeUTC)
              AND [TimestampUTC] <= @PurgeDateTimeUTC;

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
        @TableName = N'PatientData',
        @PurgeDate = @PurgeDateTimeUTC,
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
        FROM [dbo].[PatientSessions]
        WHERE [EndTimeUTC] IS NOT NULL
              AND [EndTimeUTC] <= @PurgeDateTimeUTC
              AND NOT EXISTS (SELECT 1
                              FROM [dbo].[PatientData] AS [pd]
                              WHERE [pd].[PatientSessionId] = [PatientSessions].[Id]);


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
        @TableName = N'PatientSessions',
        @PurgeDate = @PurgeDateTimeUTC,
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
        [psm]
        FROM [dbo].[PatientSessionsMap] AS [psm]
            LEFT OUTER JOIN [dbo].[PatientSessions] AS [ps]
                ON [psm].[PatientSessionId] = [ps].[Id]
        WHERE [ps].[Id] IS NULL;


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
        @TableName = N'PatientSessionsMap',
        @PurgeDate = @PurgeDateTimeUTC,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @EncounterDataPurged = @TotalRows;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge the data loader encounter data if the data is older than the specified purge date.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PurgeDlEncounterData';

