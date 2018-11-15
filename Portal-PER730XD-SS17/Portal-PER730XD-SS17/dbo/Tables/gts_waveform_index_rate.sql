CREATE TABLE [dbo].[gts_waveform_index_rate] (
    [index_rate_id]     BIGINT   IDENTITY (0, 1) NOT FOR REPLICATION NOT NULL,
    [Wave_Rate_Index]   INT      NOT NULL,
    [Current_Wavecount] INT      NOT NULL,
    [Active_Waveform]   INT      NOT NULL,
    [period_start]      DATETIME NOT NULL,
    [period_len]        INT      NOT NULL,
    [creation_date]     DATETIME CONSTRAINT [DF_gts_waveform_index_rate_creation_date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_gts_waveform_index_rate] PRIMARY KEY CLUSTERED ([index_rate_id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tracks input rate per channel and can be used to evaluate problems with waveform collection', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gts_waveform_index_rate';

