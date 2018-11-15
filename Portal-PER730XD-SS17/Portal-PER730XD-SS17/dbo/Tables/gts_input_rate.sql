CREATE TABLE [dbo].[gts_input_rate] (
    [input_rate_id] BIGINT       IDENTITY (0, 1) NOT FOR REPLICATION NOT NULL,
    [input_type]    VARCHAR (20) NOT NULL,
    [period_start]  DATETIME     NOT NULL,
    [period_len]    INT          NOT NULL,
    [rate_counter]  INT          NOT NULL,
    [creation_date] DATETIME     CONSTRAINT [DF_gts_input_rate_creation_date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_gts_input_rate_input_rate_id] PRIMARY KEY CLUSTERED ([input_rate_id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stores input rate for monitored tables. This data can be used to evaluate for possible DataLoader problems', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gts_input_rate';

