CREATE TABLE [HL7].[OutputQueue] (
    [OutputQueueID]   INT            IDENTITY (1, 1) NOT NULL,
    [MessageStatus]   CHAR (1)       NOT NULL,
    [MessageNumber]   VARCHAR (20)   NOT NULL,
    [LongText]        NVARCHAR (MAX) NOT NULL,
    [ShortText]       NVARCHAR (255) NOT NULL,
    [PatientID]       INT            NOT NULL,
    [MshSystem]       NVARCHAR (50)  NOT NULL,
    [MshOrganization] NVARCHAR (50)  NOT NULL,
    [MshEventCode]    NVARCHAR (10)  NOT NULL,
    [MshMessageType]  NVARCHAR (10)  NOT NULL,
    [SentDateTime]    DATETIME2 (7)  NOT NULL,
    [QueuedDateTime]  DATETIME2 (7)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_OutputQueue_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OutputQueue_OutputQueueID] PRIMARY KEY CLUSTERED ([OutputQueueID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [CK_OutputQueue_MessageStatus] CHECK ([MessageStatus]='R' OR [MessageStatus]='P' OR [MessageStatus]='N' OR [MessageStatus]='E'),
    CONSTRAINT [FK_OutputQueue_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OutputQueue_MessageNumber]
    ON [HL7].[OutputQueue]([MessageNumber] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_OutputQueue_QueuedDateTime]
    ON [HL7].[OutputQueue]([QueuedDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_OutputQueue_SentDateTime]
    ON [HL7].[OutputQueue]([SentDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is a queue for outbound HL/7 messages. Any messages that are being sent to another system are first copied here. Once they are sent, the status of the message is changed. A batch process can remove rows from here once messages are sent.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The status of the outbound HL/7 message (whether it has been sent or not) "N" = not sent yet "R" = sent "E" = error sending message', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'MessageStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A system generated number for this message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'MessageNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If an HL/7 message is more than 255 chars, then this represents the complete HL/7 message (most will be in here).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'LongText';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If the HL/7 message is less than 255 chars, then the message is stored here.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'ShortText';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the patient table. This is the patient this message was generated for.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sending system that is in the MSH of the outbound message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'MshSystem';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Organization identifier used in the MSH of the outbound message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'MshOrganization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HL/7 event code of this message (ex: A01, R01, etc).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'MshEventCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This higher-level Type of message (ex: ADT, ORU).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'MshMessageType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the message was successfully sent to the receiver.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'SentDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time this HL/7 message was inserted into this table. Depending on the polling cycle and how backed up the receiver is, it may be a while before it is actually sent.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'OutputQueue', @level2type = N'COLUMN', @level2name = N'QueuedDateTime';

