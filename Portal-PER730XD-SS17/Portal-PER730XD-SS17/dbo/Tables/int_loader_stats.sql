CREATE TABLE [dbo].[int_loader_stats] (
    [stat_dt] DATETIME        NOT NULL,
    [stat_tx] NVARCHAR (1000) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores statistics for the back-end processing of HL/7 messages. It stores temporary data in this table to help keep track of how many HL/7 messages have been processed since startup, etc. Data in this table is not critical and can be truncated if the back-end is not running.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_loader_stats';

