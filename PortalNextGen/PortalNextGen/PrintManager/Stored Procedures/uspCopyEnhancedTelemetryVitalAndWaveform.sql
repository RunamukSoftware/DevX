CREATE PROCEDURE [PrintManager].[uspCopyEnhancedTelemetryVitalAndWaveform]
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRANSACTION;

        EXEC [PrintManager].[uspCopyEnhancedTelemetryWaveform];

        EXEC [PrintManager].[uspCopyEnhancedTelemetryVital];

        COMMIT TRANSACTION;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copies all alarm, vitals, and waveform data relating to Enhanced Telemetry (ET) alarms for printing and reprinting. Used by the ICS_PrintJobDataCopier SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'PrintManager', @level1type = N'PROCEDURE', @level1name = N'uspCopyEnhancedTelemetryVitalAndWaveform';

