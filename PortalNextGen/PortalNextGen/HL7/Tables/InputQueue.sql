CREATE TABLE [HL7].[InputQueue] (
    [InputQueueID]                 INT            IDENTITY (1, 1) NOT NULL,
    [MessageNumber]                NUMERIC (10)   NOT NULL,
    [MessageStatus]                CHAR (1)       CONSTRAINT [DF_InputQueue_MessageStatus] DEFAULT ('N') NOT NULL,
    [QueuedDateTime]               DATETIME2 (7)  NOT NULL,
    [OutboundAnalyzedDateTime]     DATETIME2 (7)  NULL,
    [MshMessageType]               NCHAR (3)      NOT NULL,
    [MshEventCode]                 NCHAR (3)      NOT NULL,
    [MshOrganization]              NVARCHAR (36)  NOT NULL,
    [MshSystem]                    NVARCHAR (36)  NOT NULL,
    [MshDateTime]                  DATETIME2 (7)  NOT NULL,
    [MshControlID]                 NVARCHAR (36)  NOT NULL,
    [MshAcknowledgementCode]       NCHAR (2)      NULL,
    [MshVersion]                   NVARCHAR (5)   NOT NULL,
    [PatientIDMedicalRecordNumber] NVARCHAR (20)  NULL,
    [pv1_visitNumber]              NVARCHAR (50)  NULL,
    [PatientID]                    INT            NULL,
    [HL7TextShort]                 NVARCHAR (255) NULL,
    [HL7TextLong]                  NVARCHAR (MAX) NULL,
    [ProcessedDateTime]            DATETIME2 (7)  NULL,
    [ProcessedDuration]            INT            NULL,
    [ThreadID]                     INT            NULL,
    [Who]                          NVARCHAR (20)  NULL,
    [CreatedDateTime]              DATETIME2 (7)  CONSTRAINT [DF_InputQueue_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_InputQueue_InputQueueID] PRIMARY KEY CLUSTERED ([InputQueueID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_InputQueue_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_InputQueue_MessageNumber]
    ON [HL7].[InputQueue]([MessageNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is the primary queuing table for inbound HL/7 messages. All messages that are destined for any Intesys product are stored in this table. The message is originally inserted into this table with a status of "N" (not read) and later the DataLoader takes the message and does the real work of parsing it and storing the data in the appropriate tables. If it succeeds, then it changes the status to "R" (read), otherwise it flags it with a status of "E" (error). Note: Usually sites are configured to purge all successful ("R") messages after several weeks. Keeping all HL/7 messages indefinitely is generally not practical.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A system generated number for this HL7 message. This number is incremented and guarantees that if sorted ascending, you will get the messages in the same order received from the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MessageNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A status that represents the current state of this message. "N" = Not Read (not processed by loader yet) "R" = Processed by loader and no errors "E" = Processed by loader and error(s) occurred "any other value" = Ignored by loader', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MessageStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time that this message was inserted into this table (within milliseconds of receiving it in the communicator).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'QueuedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not used.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'OutboundAnalyzedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Message Type in the MSH segment (ADT, ORU, etc) . Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshMessageType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The event code in the MSH segment (A08, R01, etc). Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshEventCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sending organization (the organization in the MSH segment). Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshOrganization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sending system (The sending system in the MSH segment) Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshSystem';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time of the message (DateTime in the MSH segment). Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The control ID (Number that the external system identifies this message by). Control ID in the MSH segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshControlID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The ACK code in the MSH segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshAcknowledgementCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Version field in the MSH segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'MshVersion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The MedicalRecordNumber (MRN) field in the PID segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'PatientIDMedicalRecordNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Visit Number field in the PV1 segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'pv1_visitNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient ID in the PID segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The actual HL7 message (if <= 255 characters)', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'HL7TextShort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The actual HL7 message (if > 255 characters)', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'HL7TextLong';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the DataLoader finished processing a message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'ProcessedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The number of milliseconds that the DataLoader took to process this message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'ProcessedDuration';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The thread number within the DataLoader that processed this message. It is generally a requirement that all messages for a given patient get processed in the same thread (otherwise they may get processed out of order).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'ThreadID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not used.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InputQueue', @level2type = N'COLUMN', @level2name = N'Who';

