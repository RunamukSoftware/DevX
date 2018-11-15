CREATE TABLE [Intesys].[AlarmRetrieved] (
    [AlarmID]         INT           NOT NULL,
    [Annotation]      VARCHAR (120) NOT NULL,
    [Retrieved]       TINYINT       NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_AlarmRetrieved_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AlarmRetrieved_AlarmID] PRIMARY KEY CLUSTERED ([AlarmID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_AlarmRetrieved_CreatedDateTime]
    ON [Intesys].[AlarmRetrieved]([CreatedDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores information about alarm event retrieval.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmRetrieved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the int_alarm_event table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmRetrieved', @level2type = N'COLUMN', @level2name = N'AlarmID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Explanation of the event', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmRetrieved', @level2type = N'COLUMN', @level2name = N'Annotation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - not retrieved 1 - retrieved.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmRetrieved', @level2type = N'COLUMN', @level2name = N'Retrieved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the alarm event was retrieved.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmRetrieved', @level2type = N'COLUMN', @level2name = N'CreatedDateTime';

