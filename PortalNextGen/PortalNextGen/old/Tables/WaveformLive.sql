CREATE TABLE [old].[WaveformLive] (
    [WaveformLiveID]  BIGINT          IDENTITY (-9223372036854775808, 1) NOT NULL,
    [SampleCount]     INT             NOT NULL,
    [TypeName]        VARCHAR (50)    NOT NULL,
    [TypeID]          INT             NOT NULL,
    [Samples]         VARBINARY (MAX) NOT NULL,
    [TopicInstanceID] INT             NOT NULL,
    [StartDateTime]   DATETIME2 (7)   NOT NULL,
    [EndDateTime]     DATETIME2 (7)   NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_WaveformLive_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WaveformLive_EndTimeUTC_WaveformLiveID] PRIMARY KEY CLUSTERED ([EndDateTime] ASC, [WaveformLiveID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_WaveformLive_TopicInstanceID_TypeID_EndDateTimeUTC_StartDateTimeUTC_WaveformLiveID]
    ON [old].[WaveformLive]([TopicInstanceID] ASC, [TypeID] ASC, [EndDateTime] ASC)
    INCLUDE([StartDateTime], [WaveformLiveID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_WaveformLive_TopicInstanceID_TypeID]
    ON [old].[WaveformLive]([TopicInstanceID] ASC, [TypeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the waveform live feed data for a patient topic session.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'WaveformLive';

