CREATE PROCEDURE [old].[uspSaveEventWaveForm]
    @PatientID        INT,
    @EventID          INT,
    @WaveIndex        INT,
    @WaveformCategory INT,
    @Lead             INT,
    @Resolution       INT,
    @Height           INT,
    @WaveformType     INT,
    @Visible          TINYINT,
    @ChannelID        INT,
    @Scale            FLOAT,
    @ScaleType        INT,
    @ScaleMinimum     INT,
    @ScaleMaximum     INT,
    @Duration         INT,
    @SampleRate       INT,
    @SampleCount      INT,
    @NumberYpoints    INT,
    @Baseline         INT,
    @YpointsPerUnit   FLOAT,
    @WaveformData     VARBINARY(MAX),
    @WaveformColor    VARCHAR(50),
    @ScaleUnitType    INT
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventWaveform]
            (
                [PatientID],
                [EventID],
                [WaveformIndex],
                [WaveformCategory],
                [Lead],
                [Resolution],
                [Height],
                [WaveformType],
                [Visible],
                [ChannelID],
                [Scale],
                [ScaleType],
                [ScaleMinimum],
                [ScaleMaximum],
                [Duration],
                [SampleRate],
                [SampleCount],
                [NumberOfYPoints],
                [Baseline],
                [YPointsPerUnit],
                [WaveformData],
                [NumberOfTimeLogs],
                [WaveformColor],
                [ScaleUnitType]
            )
        VALUES
            (
                @PatientID,
                @EventID,
                @WaveIndex,
                @WaveformCategory,
                @Lead,
                @Resolution,
                @Height,
                @WaveformType,
                @Visible,
                @ChannelID,
                @Scale,
                @ScaleType,
                @ScaleMinimum,
                @ScaleMaximum,
                @Duration,
                @SampleRate,
                @SampleCount,
                @NumberYpoints,
                @Baseline,
                @YpointsPerUnit,
                @WaveformData,
                0, --@num_timelogs
                @WaveformColor,
                @ScaleUnitType
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventWaveForm';

