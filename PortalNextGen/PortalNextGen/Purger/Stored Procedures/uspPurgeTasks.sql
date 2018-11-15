CREATE PROCEDURE [Purger].[uspPurgeTasks]
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            DECLARE @ChunkSize INT = 200;

            /* Order of purging the data
        --HL7Success
        --HL7Error
        --MonitorResults
        --EventsData
        --TwelveLead
        --Alarm
        --PrintJob
        --MsgLog
        --ChunkSize
        --HL7NotRead
        --CEILog
        --DebugWaveforms
        --HL7Pending
        --Encounter
        --CHAUDITLOG
        --CHPATSETTINGS
        --CHLOGDATA
        */

            DECLARE
                @HL7SuccessPurgeDate  DATETIME2(7),
                @HL7SuccessRowsPurged INT;
            EXEC [Purger].[uspGetParameters]
                'HL7Success',
                @PurgeDate = @HL7SuccessPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @HL7ErrorPurgeDate  DATETIME2(7),
                @HL7ErrorRowsPurged INT;
            EXEC [Purger].[uspGetParameters]
                'HL7Error',
                @PurgeDate = @HL7ErrorPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @MonitorResultsPurgeDate DATETIME2(7),
                @HL7MonitorRowsPurged    INT;
            EXEC [Purger].[uspGetParameters]
                'MonitorResults',
                @PurgeDate = @MonitorResultsPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;
            --DECLARE @MonitorResultsPurgeDate DATETIME2(7) = DATEADD(HOUR, 1, dbo.fnLocalDateTimeToTime(@MonitorResultsPurgeDate)); -- add 1 hour as fnLocalDateTimeToTime does not handle daylight savings shift well

            DECLARE
                @EventsDataPurgeDate  DATETIME2(7),
                @EventsDataRowsPurged INT;
            EXEC [Purger].[uspGetWaveformParameters]
                @PurgeDate = @EventsDataPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;
            --DECLARE @EventsDataPurgeDate DATETIME2(7) = DATEADD(HOUR, 1, @EventsDataPurgeDate); -- add 1 hour as fnLocalDateTimeToTime does not handle daylight savings shift well

            DECLARE
                @TwelveLeadRowsPurgeDate DATETIME2(7),
                @TwelveLeadRowsPurged    INT;
            EXEC [Purger].[uspGetParameters]
                'TwelveLead',
                @PurgeDate = @TwelveLeadRowsPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @AlarmRowsPurgedDateTime DATETIME2(7),
                @AlarmsRowsPurged    INT;
            EXEC [Purger].[uspGetParameters]
                'Alarm',
                @PurgeDate = @AlarmRowsPurgedDateTime OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;
            --DECLARE @AlarmRowsPurgedDateTime DATETIME2(7) = DATEADD(HOUR, 1, @AlarmRowsPurgedDateTime); -- add 1 hour as fnLocalDateTimeToTime does not handle daylight savings shift well

            DECLARE
                @PrintJobsPurgedDate DATETIME2(7),
                @PrintJobsPurgeCount INT;
            EXEC [Purger].[uspGetParameters]
                'PrintJob',
                @PurgeDate = @PrintJobsPurgedDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @MessageLogPurgeDate  DATETIME2(7),
                @MessageLogPurgeCount INT;
            EXEC [Purger].[uspGetParameters]
                'MsgLog',
                @PurgeDate = @MessageLogPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @HL7NotReadPurgedDate DATETIME2(7),
                @HL7NotReadPurged     INT;
            EXEC [Purger].[uspGetParameters]
                'HL7NotRead',
                @PurgeDate = @HL7NotReadPurgedDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @CEILogPurgeDate DATETIME2(7),
                @CEILogPurged    INT;
            EXEC [Purger].[uspGetParameters]
                'CEILog',
                @PurgeDate = @CEILogPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @WaveformPurgeDateTime  DATETIME2(7),
                @WaveformDataPurged INT;
            EXEC [Purger].[uspGetWaveformParameters]
                @PurgeDate = @WaveformPurgeDateTime OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;
            --DECLARE @WaveformPurgeDateTime DATETIME2(7) = DATEADD(HOUR, 1, @WaveformPurgeDateTime); -- add 1 hour as fnLocalDateTimeToTime does not handle daylight savings shift well

            DECLARE
                @HL7PendingPurgeDate  DATETIME2(7),
                @HL7PendingDataPurged INT;
            EXEC [Purger].[uspGetParameters]
                'HL7Pending',
                @PurgeDate = @HL7PendingPurgeDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE @EncounterDataPurged INT;

            DECLARE
                @CHAuditLogDate    DATETIME2(7),
                @ChAuditDataPurged INT;
            EXEC [Purger].[uspGetParameters]
                'CHAUDITLOG',
                @PurgeDate = @CHAuditLogDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @CHPatientSettingsDate     DATETIME2(7),
                @PatientSettingsDataPurged INT;
            EXEC [Purger].[uspGetParameters]
                'CHPATSETTINGS',
                @PurgeDate = @CHPatientSettingsDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            DECLARE
                @CHLogDataDate   DATETIME2(7),
                @CHLogDataPurged INT;
            EXEC [Purger].[uspGetParameters]
                'CHLOGDATA',
                @PurgeDate = @CHLogDataDate OUTPUT,
                @ChunkSize = @ChunkSize OUTPUT;

            SET @HL7SuccessRowsPurged = 0; --Initial value
            SET @HL7ErrorRowsPurged = 0; --Initial value
            SET @HL7MonitorRowsPurged = 0; --Initial value
            SET @EventsDataRowsPurged = 0; --Initial value
            SET @TwelveLeadRowsPurged = 0; --Initial value
            SET @AlarmsRowsPurged = 0; --Initial value
            SET @PrintJobsPurgeCount = 0; --Initial value
            SET @MessageLogPurgeCount = 0; --Initial value
            SET @HL7NotReadPurged = 0; --Initial value
            SET @CEILogPurged = 0; --Initial value
            SET @WaveformDataPurged = 0; --Initial value
            SET @HL7PendingDataPurged = 0; --Initial value
            SET @ChAuditDataPurged = 0; --Initial value
            SET @EncounterDataPurged = 0; --Initial value
            SET @PatientSettingsDataPurged = 0; --Initial value
            SET @CHLogDataPurged = 0; --Initial value

            DECLARE
                @ErrorMessage   NVARCHAR(4000),
                @ErrorNumber    INT,
                @ErrorSeverity  INT,
                @ErrorState     INT,
                @ErrorLine      INT,
                @ErrorProcedure NVARCHAR(200);

            BEGIN TRY
                /* To purge the HL7 Success data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteHL7Success]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @HL7SuccessPurgeDate,
                    @HL7SuccessRowsPurged = @HL7SuccessRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@HL7SuccessRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteHL7_Success) at configured time interval : '
                       + RTRIM(CAST(@HL7SuccessPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                -- Assign variables to error-handling functions that capture information for RAISERROR.
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                -- Build the message string that will contain original error information.
                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                -- Raise an error: msg_str parameter of RAISERROR will contain the original error information.
                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the HL7 Error data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteHL7Error]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @HL7ErrorPurgeDate,
                    @HL7ErrorRowsPurged = @HL7ErrorRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@HL7ErrorRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteHL7_Error) at configured time interval : '
                       + RTRIM(CAST(@HL7ErrorPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Monitor data which is older than the configured interval*/
                SET @HL7MonitorRowsPurged = 0; --Resetting
                EXEC [Purger].[uspDeleteResult]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @MonitorResultsPurgeDate,
                    @HL7MonitorRowsPurged = @HL7MonitorRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@HL7MonitorRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteResult_Data) at configured time interval : '
                       + RTRIM(CAST(@MonitorResultsPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Monitor data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteDataLoaderEvent]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @EventsDataPurgeDate,
                    @EventsDataRowsPurged = @EventsDataRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@EventsDataRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspPurgeEventsData) at configured time interval : '
                       + RTRIM(CAST(@EventsDataPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                SET @HL7MonitorRowsPurged = 0; --Resetting
                EXEC [Purger].[uspDeleteDataLoaderVital]
                    @ChunkSize = @ChunkSize,
                    @PurgeDateTime = @MonitorResultsPurgeDate,
                    @HL7MonitorRowsPurged = @HL7MonitorRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@HL7MonitorRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspPurgeDlVitalsData) at configured time interval : '
                       + RTRIM(CAST(@MonitorResultsPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the TweleveLead data which is older than the configured interval*/
                EXEC [Purger].[uspPurgeTwelveLeadData]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @TwelveLeadRowsPurgeDate,
                    @TwelveLeadRowsPurged = @TwelveLeadRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@TwelveLeadRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDelete12Lead_Data) at configured time interval : '
                       + RTRIM(CAST(@TwelveLeadRowsPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Alarm data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteAlarm]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @AlarmRowsPurgedDateTime,
                    @AlarmsRowsPurged = @AlarmsRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@AlarmsRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteAlarm_Data) at configured time interval : '
                       + RTRIM(CAST(@AlarmRowsPurgedDateTime AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                SET @AlarmsRowsPurged = 0; --Resetting
                EXEC [Purger].[uspDeleteDataLoaderAlarmData]
                    @ChunkSize = @ChunkSize,
                    @PurgeDateTime = @AlarmRowsPurgedDateTime,
                    @AlarmsRowsPurged = @AlarmsRowsPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@AlarmsRowsPurged AS VARCHAR(20))
                       + ') purged from ICS (uspPurgeDlAlarmData) at configured time interval : '
                       + RTRIM(CAST(@AlarmRowsPurgedDateTime AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Prints jobs data which is older than the configured interval*/
                EXEC [Purger].[uspDeletePrintJob]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @PrintJobsPurgedDate,
                    @PrintJobsPurged = @PrintJobsPurgeCount OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@PrintJobsPurgeCount AS VARCHAR(20))
                       + ') purged from ICS (uspDeletePrint_Job_Data) at configured time interval : '
                       + RTRIM(CAST(@PrintJobsPurgedDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            /*
        SET @PrintJobsPurgeCount = 0; --Resetting the value
        -- NO DL PRINT JOBS USED IN THE CURRENT ICS VERSION
        EXEC [old].[uspPurgeDlPrintJobsData] @ChunkSize = @ChunkSize, @PurgeDate = @PrintJobsPurgedDate, @PrintJobsPurgeCount = @PrintJobsPurgeCount OUTPUT
        PRINT(CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records (' + CAST(@PrintJobsPurgeCount AS VARCHAR(20)) + ') purged from ICS (uspPurgeDlPrintJobsData) at configured time interval : ' + RTRIM(CAST(@PrintJobsPurgedDate AS VARCHAR(30))) +  '.');
        */

            BEGIN TRY
                SET @PrintJobsPurgeCount = 0; -- Resetting
                EXEC [Purger].[uspDeleteEnhancedTelemetryPrintJob]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @PrintJobsPurgedDate,
                    @PrintJobsPurged = @PrintJobsPurgeCount OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@PrintJobsPurgeCount AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteETPrintJobs_Data) at configured time interval : '
                       + RTRIM(CAST(@PrintJobsPurgedDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Message log data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteMessageLog]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @MessageLogPurgeDate,
                    @MessageLogPurged = @MessageLogPurgeCount OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@MessageLogPurgeCount AS VARCHAR(20))
                       + ') purged from ICS (uspDeletemsg_Log_Data) at configured time interval : '
                       + RTRIM(CAST(@MessageLogPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the HL7 Not Read data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteHL7NotRead]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @HL7NotReadPurgedDate,
                    @HL7NotReadPurged = @HL7NotReadPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@HL7NotReadPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteHL7_Not_Read) at configured time interval : '
                       + RTRIM(CAST(@HL7NotReadPurgedDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the CEI data which is older than the configured interval*/
                EXEC [CEI].[uspPurgeLogData]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @CEILogPurgeDate,
                    @CEILogPurged = @CEILogPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@CEILogPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteCEI_Log_Data) at configured time interval : '
                       + RTRIM(CAST(@CEILogPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Waveform data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteWaveform]
                    @ChunkSize = @ChunkSize,
                    @PurgeDateTime = @WaveformPurgeDateTime,
                    @WaveformDataPurged = @WaveformDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@WaveformDataPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteWaveForm_Data) at configured time interval : '
                       + RTRIM(CAST(@WaveformPurgeDateTime AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                SET @WaveformDataPurged = 0; --Resetting
                EXEC [Purger].[uspDeleteDataLoaderWaveform]
                    @ChunkSize = @ChunkSize,
                    @PurgeDateUTC = @WaveformPurgeDateTime,
                    @WaveformDataPurged = @WaveformDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@WaveformDataPurged AS VARCHAR(20))
                       + ') purged from ICS (uspPurgeDlWaveformData) at configured time interval : '
                       + RTRIM(CAST(@WaveformPurgeDateTime AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the HL7 Pending data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteHL7Pending]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @HL7PendingPurgeDate,
                    @HL7PendingDataPurged = @HL7PendingDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@HL7PendingDataPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeleteHL7_Pending) at configured time interval : '
                       + RTRIM(CAST(@HL7PendingPurgeDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the Encounter data(here the purge is doing for the date before 10 days*/
                EXEC [Purger].[uspDeleteEncounterData]
                    @ChunkSize = @ChunkSize,
                    @EncounterDataPurged = @EncounterDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@EncounterDataPurged AS VARCHAR(20)) + ') purged from ICS (uspDeleteEncounter_Data).'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                SET @EncounterDataPurged = 0; --Resetting
                EXEC [Purger].[uspDeleteDataLoaderEncounterData]
                    @ChunkSize = @ChunkSize,
                    @EncounterDataPurged = @EncounterDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@EncounterDataPurged AS VARCHAR(20)) + ') purged from ICS (uspPurgeDlEncounterData).'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the CH Audit log data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteChAuditLog]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @CHAuditLogDate,
                    @ChAuditDataPurged = @ChAuditDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@ChAuditDataPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeletech_Audit_Log) at configured time interval : '
                       + RTRIM(CAST(@CHAuditLogDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the CH Patient Settings data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteChPatientSettings]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @CHPatientSettingsDate,
                    @PatientSettingsDataPurged = @PatientSettingsDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@PatientSettingsDataPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeletech_Patient_Settings) at configured time interval : '
                       + RTRIM(CAST(@CHPatientSettingsDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;

            BEGIN TRY
                /* To purge the CH Log data which is older than the configured interval*/
                EXEC [Purger].[uspDeleteChLogData]
                    @ChunkSize = @ChunkSize,
                    @PurgeDate = @CHLogDataDate,
                    @CHLogDataPurged = @CHLogDataPurged OUTPUT;
                PRINT (CONVERT(VARCHAR(30), SYSUTCDATETIME(), 121) + ' -- Records ('
                       + CAST(@CHLogDataPurged AS VARCHAR(20))
                       + ') purged from ICS (uspDeletech_Log_Data) at configured time interval : '
                       + RTRIM(CAST(@CHLogDataDate AS VARCHAR(30))) + '.'
                      );
            END TRY
            BEGIN CATCH
                SELECT
                    @ErrorNumber    = ERROR_NUMBER(),
                    @ErrorSeverity  = ERROR_SEVERITY(),
                    @ErrorState     = ERROR_STATE(),
                    @ErrorLine      = ERROR_LINE(),
                    @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

                SELECT
                    @ErrorMessage
                    = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                      + COALESCE(ERROR_MESSAGE(), N'(null)');

                RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
            END CATCH;
        END TRY
        BEGIN CATCH
            SELECT
                @ErrorNumber    = ERROR_NUMBER(),
                @ErrorSeverity  = ERROR_SEVERITY(),
                @ErrorState     = ERROR_STATE(),
                @ErrorLine      = ERROR_LINE(),
                @ErrorProcedure = COALESCE(ERROR_PROCEDURE(), N'(null)');

            -- Use RAISERROR inside the CATCH block to return error
            -- information about the original error that caused
            -- execution to jump to the CATCH block.
            -- Build the message string that will contain original error information.
            SELECT
                @ErrorMessage
                = N'ICS Purger Error: %d, Level %d, State %d, Procedure %s, Line %d, Message: '
                  + COALESCE(ERROR_MESSAGE(), N'(null)');

            -- Raise an error: msg_str parameter of RAISERROR will contain the original error information.
            RAISERROR(@ErrorMessage, 10, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine) WITH LOG;
        END CATCH;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Execute all of the purging tasks with error handling and error reporting to Windows event log.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspPurgeTasks';

