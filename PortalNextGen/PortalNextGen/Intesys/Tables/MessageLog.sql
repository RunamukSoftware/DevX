CREATE TABLE [Intesys].[MessageLog] (
    [MessageLogID]      INT            IDENTITY (1, 1) NOT NULL,
    [MessageDateTime]   DATETIME2 (7)  NOT NULL,
    [Product]           NVARCHAR (20)  NOT NULL,
    [MessageTemplateID] INT            NOT NULL,
    [ExternalID]        VARCHAR (50)   NOT NULL,
    [MessageText]       NVARCHAR (MAX) NOT NULL,
    [Type]              NVARCHAR (20)  NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)  CONSTRAINT [DF_MessageLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MessageLog_MessageLogID] PRIMARY KEY CLUSTERED ([MessageLogID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MessageLog_ExternalID_MessageLogID]
    ON [Intesys].[MessageLog]([ExternalID] ASC, [MessageLogID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_MessageLog_MessageDateTime]
    ON [Intesys].[MessageLog]([MessageDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores messages that are produced from the system back-end. It is used to log messages that may or may not be related to HL/7 processing. Most of the rows in this table come about from informational msgs or errors related to HL/7 processing. Purging of this table may need to be done periodically (or done with the purging of the HL7_in_queue table).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'MessageLog';

