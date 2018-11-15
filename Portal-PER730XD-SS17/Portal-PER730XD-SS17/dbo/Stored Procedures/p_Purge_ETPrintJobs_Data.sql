CREATE PROCEDURE [dbo].[p_Purge_ETPrintJobs_Data]
    (
    @FChunkSize INT,
    @PurgeDate DATETIME,
    @PrintJobsPurged INT OUTPUT)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PurgeDateUTC DATETIME = [dbo].[fnLocalDateTimeToUtcTime](@PurgeDate);
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
        -- Delete alarm data
        DELETE TOP (@FChunkSize)
        [ipjea]
        FROM [dbo].[int_print_job_et_alarm] AS [ipjea]
        WHERE [ipjea].[AlarmStartTimeUTC] <= @PurgeDateUTC;

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
        @TableName = N'int_print_job_et_alarm',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    -- Delete vitals data
    SELECT DISTINCT
           [Vitals].[Id]
    INTO [#vitalsToDelete]
    FROM [dbo].[int_print_job_et_vitals] AS [Vitals]
        LEFT OUTER JOIN [dbo].[int_print_job_et_alarm] AS [Alarm]
            ON [Vitals].[TopicSessionId] = [Alarm].[TopicSessionId]
               AND [Vitals].[ResultTimeUTC] >= [Alarm].[AlarmStartTimeUTC]
               AND [Vitals].[ResultTimeUTC] <= [Alarm].[AlarmEndTimeUTC]
    WHERE [Alarm].[TopicSessionId] IS NULL; -- We only want the Ids where there is no corresponding Alarm

    SET @Loop = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [ipjev]
        FROM [dbo].[int_print_job_et_vitals] AS [ipjev]
        WHERE [ipjev].[Id] IN (SELECT [Id] FROM [#vitalsToDelete]);

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
        @TableName = N'int_print_job_et_vitals',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    -- Delete waveform data
    SELECT [Waveform].[Id]
    INTO [#waveformsToDelete]
    FROM [dbo].[int_print_job_et_waveform] AS [Waveform]
        LEFT OUTER JOIN [dbo].[int_print_job_et_alarm] AS [Alarm]
            ON [Waveform].[DeviceSessionId] = [Alarm].[DeviceSessionId]
               AND [Waveform].[StartTimeUTC] < [Alarm].[AlarmEndTimeUTC]
               AND [Waveform].[EndTimeUTC] > [Alarm].[AlarmStartTimeUTC]
    WHERE [Alarm].[TopicSessionId] IS NULL; -- We only want the Ids where there is no corresponding Alarm

    SET @Loop = 1;

    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [ipjew]
        FROM [dbo].[int_print_job_et_waveform] AS [ipjew]
        WHERE [ipjew].[Id] IN (SELECT [Id] FROM [#waveformsToDelete]);

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
        @TableName = N'int_print_job_et_waveform',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @PrintJobsPurged = @TotalRows;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purges old alarm report data previously saved for ET Print Jobs.  Used by the ICS_PurgeData SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_ETPrintJobs_Data';
