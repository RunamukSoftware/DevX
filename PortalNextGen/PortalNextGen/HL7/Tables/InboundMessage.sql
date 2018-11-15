CREATE TABLE [HL7].[InboundMessage] (
    [InboundMessageID]          INT            IDENTITY (1, 1) NOT NULL,
    [MessageNumber]             INT            NOT NULL,
    [MessageStatus]             CHAR (1)       NOT NULL,
    [HL7Message]                NVARCHAR (MAX) NOT NULL,
    [HL7MessageResponse]        NVARCHAR (MAX) NOT NULL,
    [MessageSendingApplication] NVARCHAR (180) NOT NULL,
    [MessageSendingFacility]    NVARCHAR (180) NOT NULL,
    [MessageType]               NCHAR (3)      NOT NULL,
    [MessageTypeEventCode]      NCHAR (3)      NOT NULL,
    [MessageControlID]          NVARCHAR (20)  NOT NULL,
    [MessageVersion]            NVARCHAR (60)  NOT NULL,
    [MessageHeaderDate]         DATETIME2 (7)  NOT NULL,
    [MessageQueuedDate]         DATETIME2 (7)  NOT NULL,
    [MessageProcessedDate]      DATETIME2 (7)  NULL,
    [CreatedDateTime]           DATETIME2 (7)  CONSTRAINT [DF_InboundMessage_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_InboundMessage_InboundMessageID] PRIMARY KEY CLUSTERED ([InboundMessageID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [CK_InboundMessage_MessageStatus] CHECK ([MessageStatus]='R' OR [MessageStatus]='E')
);


GO
CREATE NONCLUSTERED INDEX [IX_HL7InboundMessage_MessageProcessedDate]
    ON [HL7].[InboundMessage]([MessageProcessedDate] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HL7InboundMessage_MessageNumber]
    ON [HL7].[InboundMessage]([MessageNumber] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_HL7InboundMessage_MessageStatus_MessageQueuedDate_MessageProcessedDate_MessageNumber]
    ON [HL7].[InboundMessage]([MessageStatus] ASC, [MessageQueuedDate] ASC, [MessageProcessedDate] ASC)
    INCLUDE([MessageNumber]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'InboundMessage';

