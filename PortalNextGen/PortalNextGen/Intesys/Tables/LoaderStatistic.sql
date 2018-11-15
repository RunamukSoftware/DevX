CREATE TABLE [Intesys].[LoaderStatistic] (
    [LoaderStatisticID]     INT             IDENTITY (1, 1) NOT NULL,
    [StatisticDateTime]     DATETIME2 (7)   NOT NULL,
    [StatisticTransmission] NVARCHAR (1000) NULL,
    [CreatedDateTime]       DATETIME2 (7)   CONSTRAINT [DF_LoaderStatistic_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_LoaderStatistic_LoaderStatisticID] PRIMARY KEY CLUSTERED ([LoaderStatisticID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores statistics for the back-end processing of HL/7 messages. It stores temporary data in this table to help keep track of how many HL/7 messages have been processed since startup, etc. Data in this table is not critical and can be truncated if the back-end is not running.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'LoaderStatistic';

