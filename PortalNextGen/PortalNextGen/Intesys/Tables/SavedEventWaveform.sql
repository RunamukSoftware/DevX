CREATE TABLE [Intesys].[SavedEventWaveform] (
    [PatientID]         INT             NOT NULL,
    [OriginalPatientID] INT             NULL,
    [EventID]           BIGINT          NOT NULL,
    [WaveformIndex]     INT             NOT NULL,
    [WaveformCategory]  INT             NOT NULL,
    [Lead]              INT             NOT NULL,
    [Resolution]        INT             NOT NULL,
    [Height]            INT             NOT NULL,
    [WaveformType]      INT             NOT NULL,
    [Visible]           TINYINT         NOT NULL,
    [ChannelID]         INT             NOT NULL,
    [Scale]             FLOAT (53)      NOT NULL,
    [ScaleType]         INT             NOT NULL,
    [ScaleMinimum]      INT             NOT NULL,
    [ScaleMaximum]      INT             NOT NULL,
    [ScaleUnitType]     INT             NOT NULL,
    [Duration]          INT             NOT NULL,
    [SampleRate]        INT             NOT NULL,
    [SampleCount]       INT             NOT NULL,
    [NumberOfYPoints]   INT             NOT NULL,
    [Baseline]          INT             NOT NULL,
    [YPointsPerUnit]    FLOAT (53)      NOT NULL,
    [WaveformData]      VARBINARY (MAX) NULL,
    [NumberOfTimeLogs]  INT             NOT NULL,
    [TimeLogData]       VARBINARY (MAX) NULL,
    [WaveformColor]     VARCHAR (50)    NULL,
    [CreatedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_SavedEventWaveform_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SavedEventWaveform_PatientID_EventID_ChannelID] PRIMARY KEY CLUSTERED ([PatientID] ASC, [EventID] ASC, [ChannelID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_SavedEventWaveform_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_SavedEventWaveform_PatientSavedEvent_PatientID_EventID] FOREIGN KEY ([PatientID], [EventID]) REFERENCES [Intesys].[PatientSavedEvent] ([PatientID], [EventID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SavedEventWaveform_PatientID_EventID]
    ON [Intesys].[SavedEventWaveform]([PatientID] ASC, [EventID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains waveform data for a given saved event. It should have PatientID, EventID, and wave_index as PKs. The EventID column corresponds to the EventID column in the SavedEvent table. There can be several rows in this table for a given saved event (one for each waveform in the saved event).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventWaveform';

