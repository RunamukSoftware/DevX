CREATE PROCEDURE [dbo].[p_Purge_HL7_Not_Read]
    (
    @FChunkSize INT,
    @PurgeDate DATETIME,
    @HL7NotReadPurged INT OUTPUT)
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

    /* HL7 NOT READ */
    /* Fix for CR #2676 by Nancy on 1/16/08, Fail to purge due to sent_dt is null */
    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [dbo].[int_msg_log]
        FROM [dbo].[HL7_out_queue]
        WHERE [msg_no] = [external_id]
              AND [msg_status] = N'N'
              AND ([sent_dt] < @PurgeDate
                   OR [queued_dt] < @PurgeDate);

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
        @TableName = N'int_msg_log',
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
        [dbo].[HL7_msg_ack]
        FROM [dbo].[HL7_out_queue] AS [HL7OQ]
        WHERE [msg_control_id] = [HL7OQ].[msg_no]
              AND [HL7OQ].[msg_status] = N'N'
              AND ([HL7OQ].[sent_dt] < @PurgeDate
                   OR [HL7OQ].[queued_dt] < @PurgeDate);

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
        @TableName = N'HL7_out_queue',
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
        [iml]
        FROM [dbo].[int_msg_log] AS [iml]
        WHERE [iml].[external_id] IN (SELECT CONVERT(VARCHAR(20), [MessageNo])
                                      FROM [dbo].[HL7InboundMessage]
                                      WHERE [MessageStatus] = N'N'
                                            AND [MessageProcessedDate] < @PurgeDate);

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
        @TableName = N'int_msg_log',
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
        [hoq]
        FROM [dbo].[HL7_out_queue] AS [hoq]
        WHERE [hoq].[msg_status] = N'N'
              AND ([hoq].[sent_dt] < @PurgeDate
                   OR [hoq].[queued_dt] < @PurgeDate);

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
        @TableName = N'HL7_out_queue',
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
        [hpl]
        FROM [dbo].[HL7PatientLink] AS [hpl]
        WHERE [MessageNo] IN (SELECT [MessageNo]
                              FROM [dbo].[HL7InboundMessage]
                              WHERE [MessageStatus] = N'N'
                                    AND [MessageProcessedDate] < @PurgeDate);

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
        @TableName = N'HL7PatientLink',
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
        [him]
        FROM [dbo].[HL7InboundMessage] AS [him]
        WHERE [him].[MessageStatus] = N'N'
              AND [him].[MessageProcessedDate] < @PurgeDate;

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
        @TableName = N'HL7InboundMessage',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @TotalRows = 0;
    SET @Loop = 1;

    -- Purge non-processed messages based on MessageQueuedDate if MessageProcessedDate is null.
    WHILE (@Loop > 0)
    BEGIN TRY
        DELETE TOP (@FChunkSize)
        [him]
        FROM [dbo].[HL7InboundMessage] AS [him]
        WHERE [him].[MessageStatus] = N'N'
              AND [him].[MessageProcessedDate] IS NULL
              AND [him].[MessageQueuedDate] < @PurgeDate;

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
        @TableName = N'HL7InboundMessage',
        @PurgeDate = @PurgeDate,
        @Parameters = '',
        @ChunkSize = @ChunkSize,
        @Rows = @TotalRows,
        @ErrorNumber = @ErrorNumber,
        @ErrorMessage = @ErrorMessage,
        @StartDateTimeUTC = @StartDateTimeUTC;

    SET @HL7NotReadPurged = @TotalRows;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_HL7_Not_Read';

