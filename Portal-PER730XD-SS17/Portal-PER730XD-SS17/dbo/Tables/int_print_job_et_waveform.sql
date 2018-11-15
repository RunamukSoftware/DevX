CREATE TABLE [dbo].[int_print_job_et_waveform] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [DeviceSessionId] UNIQUEIDENTIFIER NOT NULL,
    [StartTimeUTC]    DATETIME         NOT NULL,
    [EndTimeUTC]      DATETIME         NOT NULL,
    [SampleRate]      INT              NOT NULL,
    [WaveformData]    VARBINARY (MAX)  NOT NULL,
    [ChannelCode]     INT              NOT NULL,
    [CdiLabel]        VARCHAR (255)    NOT NULL,
    CONSTRAINT [PK_int_print_job_et_waveform_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_print_job_et_waveform';

