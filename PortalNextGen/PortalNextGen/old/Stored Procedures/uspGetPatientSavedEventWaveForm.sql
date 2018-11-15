CREATE PROCEDURE [old].[uspGetPatientSavedEventWaveForm]
    (
        @PatientID INT,
        @EventID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isewf].[ChannelID],
            [isewf].[WaveformCategory] AS [Type],
            [isewf].[Scale]            AS [ScaleValue],
            [isewf].[ScaleMinimum],
            [isewf].[ScaleMaximum],
            [isewf].[ScaleType],
            [isewf].[SampleRate],
            [isewf].[SampleCount],
            [isewf].[NumberOfYPoints],
            [isewf].[Baseline],
            [isewf].[YPointsPerUnit],
            [isewf].[Visible],
            [ict].[Label],
            [isewf].[WaveformData],
            [isewf].[NumberOfTimeLogs],
            [isewf].[TimeLogData],
            [isewf].[WaveformColor],
            [isewf].[ScaleUnitType]
        FROM
            [Intesys].[SavedEventWaveform] AS [isewf]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [isewf].[WaveformCategory] = [ict].[ChannelCode]
        WHERE
            [isewf].[PatientID] = @PatientID
            AND [isewf].[EventID] = @EventID
            AND [isewf].[Visible] = 1
        ORDER BY
            [isewf].[WaveformIndex];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEventWaveForm';

