CREATE TABLE [Intesys].[EventLog] (
    [EventLogID]      INT            IDENTITY (1, 1) NOT NULL,
    [EventID]         BIGINT         NOT NULL,
    [PatientID]       INT            NOT NULL,
    [Type]            NVARCHAR (30)  NOT NULL,
    [EventDateTime]   DATETIME2 (7)  NOT NULL,
    [SequenceNumber]  INT            NOT NULL,
    [Client]          NVARCHAR (50)  NOT NULL,
    [Description]     NVARCHAR (300) NOT NULL,
    [Status]          INT            NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_EventLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_EventLog_EventLogID] PRIMARY KEY CLUSTERED ([EventLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_EventLog_Event_EventID] FOREIGN KEY ([EventID]) REFERENCES [old].[Event] ([EventID]),
    CONSTRAINT [FK_EventLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores information about events.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Event ID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'EventID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Status', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Event Type', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of the event', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'EventDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequential number', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'SequenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client name', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'Client';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description of the event', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Status', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventLog', @level2type = N'COLUMN', @level2name = N'Status';

