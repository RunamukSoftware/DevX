CREATE TABLE [dbo].[int_alarm_retrieved] (
    [alarm_id]   UNIQUEIDENTIFIER NOT NULL,
    [annotation] VARCHAR (120)    NULL,
    [retrieved]  TINYINT          NULL,
    [insert_dt]  DATETIME         NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_alarm_retrieved_alarm_id]
    ON [dbo].[int_alarm_retrieved]([alarm_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_alarm_retrieved_insert_dt]
    ON [dbo].[int_alarm_retrieved]([insert_dt] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores information about alarm event retrieval.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_retrieved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the int_alarm_event table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_retrieved', @level2type = N'COLUMN', @level2name = N'alarm_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Explanation of the event', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_retrieved', @level2type = N'COLUMN', @level2name = N'annotation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - not retrieved 1 - retrieved.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_retrieved', @level2type = N'COLUMN', @level2name = N'retrieved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the alarm event was retrieved.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_retrieved', @level2type = N'COLUMN', @level2name = N'insert_dt';

