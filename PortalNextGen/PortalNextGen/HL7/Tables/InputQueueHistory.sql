CREATE TABLE [HL7].[InputQueueHistory] (
    [InputQueueHistoryID]      INT            IDENTITY (1, 1) NOT NULL,
    [MessageNumber]            NUMERIC (10)   NOT NULL,
    [RecordID]                 INT            NOT NULL,
    [MessageStatus]            CHAR (1)       NOT NULL,
    [QueuedDateTime]           DATETIME2 (7)  NOT NULL,
    [OutboundAnalyzedDateTime] DATETIME2 (7)  NULL,
    [HL7TextShort]             NVARCHAR (255) NULL,
    [HL7TextLong]              NVARCHAR (MAX) NULL,
    [ProcessedDateTime]        DATETIME2 (7)  NULL,
    [ProcessedDuration]        INT            NULL,
    [ThreadID]                 INT            NULL,
    [Who]                      NVARCHAR (20)  NULL,
    [CreatedDateTime]          DATETIME2 (7)  CONSTRAINT [DF_InputQueueHistory_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_InputQueueHistory_InputQueueHistoryID] PRIMARY KEY CLUSTERED ([InputQueueHistoryID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_InputQueueHistory_MessageNumber_RecordID]
    ON [HL7].[InputQueueHistory]([MessageNumber] ASC, [RecordID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores a history of any HL/7 messages that are replayed in order to correct data issues. The HL7 services provides a mechanism to replay an HL/7 message (with changes) in order to fix data problems. This table ensures any such replays are audited.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The internal ID for the HL7 message that was replayed. FK to the HL7_in_queue table (although it may be purged from that table).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'MessageNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sequence number (if replayed multiple times).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'RecordID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The status of the original HL/7 message (before replaying).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'MessageStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the original HL7 message was queued. When a message is replayed, this date is updated to the new time.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'QueuedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not used', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'OutboundAnalyzedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original HL7 message (if <= 255 characters long)', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'HL7TextShort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original HL7 message (if > 255 characters long).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'HL7TextLong';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the original message was processed.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'ProcessedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The duration (in milliseconds) that the original HL7 message took to process.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'ProcessedDuration';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The thread ID that the HL7 message was processed on. This is helpful for debugging.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'ThreadID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The person who caused the replay (either a login ID or name).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueueHistory', @level2type = N'COLUMN', @level2name = N'Who';

