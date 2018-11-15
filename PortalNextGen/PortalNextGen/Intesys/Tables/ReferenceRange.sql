CREATE TABLE [Intesys].[ReferenceRange] (
    [ReferenceRangeID] INT           NOT NULL,
    [ReferenceRange]   NVARCHAR (60) NOT NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_ReferenceRange_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ReferenceRange_ReferenceRangeID] PRIMARY KEY CLUSTERED ([ReferenceRangeID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceRange_ReferenceRangeID]
    ON [Intesys].[ReferenceRange]([ReferenceRangeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains the results value ranges that are associated with a specific RESULT.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ReferenceRange';

