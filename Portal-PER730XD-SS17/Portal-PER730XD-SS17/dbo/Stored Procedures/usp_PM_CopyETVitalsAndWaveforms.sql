CREATE PROCEDURE [dbo].[usp_PM_CopyETVitalsAndWaveforms]
AS
BEGIN
    BEGIN TRANSACTION;

    EXEC [dbo].[usp_PM_CopyETWaveformData];

    EXEC [dbo].[usp_PM_CopyETVitalsData];

    COMMIT TRANSACTION;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copies all alarm, vitals, and waveform data relating to ET alarms for printing and reprinting. Used by the ICS_PrintJobDataCopier SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PM_CopyETVitalsAndWaveforms';

