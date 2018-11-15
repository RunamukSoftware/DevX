CREATE TABLE [dbo].[PacerSpikeLog] (
    [user_id]     UNIQUEIDENTIFIER NOT NULL,
    [patient_id]  UNIQUEIDENTIFIER NOT NULL,
    [sample_rate] SMALLINT         NOT NULL,
    [start_ft]    BIGINT           NOT NULL,
    [num_spikes]  INT              NOT NULL,
    [spike_data]  IMAGE            NOT NULL,
     [Sequence] BIGINT IDENTITY(-9223372036854775808, 1) NOT NULL,
    CONSTRAINT [PK_PacerSpikeLog_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PacerSpikeLog_AnalysisTime_user_id_patient_id] FOREIGN KEY ([user_id], [patient_id]) REFERENCES [dbo].[AnalysisTime] ([user_id], [patient_id]) ON DELETE CASCADE
);
GO
CREATE NONCLUSTERED INDEX [IX_PacerSpikeLog_user_id_patient_id_sample_rate] ON [dbo].[PacerSpikeLog] ([user_id] ASC, [patient_id] ASC, [sample_rate] ASC) WITH (FILLFACTOR = 100)
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains pacer spike information (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PacerSpikeLog';
