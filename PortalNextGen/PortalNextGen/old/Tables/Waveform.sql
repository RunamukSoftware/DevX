CREATE TABLE [old].[Waveform] (
    [WaveformID]      BIGINT          IDENTITY (-9223372036854775808, 1) NOT NULL,
    [SampleCount]     INT             NOT NULL,
    [TypeName]        VARCHAR (50)    NOT NULL,
    [TypeID]          INT             NOT NULL,
    [Samples]         VARBINARY (MAX) NOT NULL,
    [Compressed]      BIT             NOT NULL,
    [TopicSessionID]  INT             NOT NULL,
    [StartDateTime]   DATETIME2 (7)   NOT NULL,
    [EndDateTime]     DATETIME2 (7)   NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_Waveform_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Waveform_StartTimeUTC_WaveformID] PRIMARY KEY CLUSTERED ([StartDateTime] ASC, [WaveformID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Waveform_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Waveform_TopicSessionID_StartDateTime_EndDateTime_TypeID_Samples]
    ON [old].[Waveform]([TopicSessionID] ASC, [StartDateTime] ASC, [EndDateTime] ASC, [TypeID] ASC)
    INCLUDE([Samples]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Waveform';

