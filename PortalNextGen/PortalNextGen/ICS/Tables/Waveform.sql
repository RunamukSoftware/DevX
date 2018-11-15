CREATE TABLE [ICS].[Waveform] (
    [WaveformID]      BIGINT          NOT NULL,
    [ParameterID]     INT             NOT NULL,
    [SampleCount]     INT             NOT NULL,
    [TypeName]        VARCHAR (50)    NOT NULL,
    [TypeID]          INT             NOT NULL,
    [Samples]         VARBINARY (MAX) NOT NULL,
    [Compressed]      BIT             NOT NULL,
    [TopicSessionID]  INT             NOT NULL,
    [StartDateTime]   DATETIME2 (7)   NOT NULL,
    [EndDateTime]     DATETIME2 (7)   NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_Waveform_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Waveform_WaveformID] PRIMARY KEY CLUSTERED ([WaveformID] ASC),
    CONSTRAINT [FK_Waveform_Parameter_ParameterID] FOREIGN KEY ([ParameterID]) REFERENCES [ICS].[Parameter] ([ParameterID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Waveform';

