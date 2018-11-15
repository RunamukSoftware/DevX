CREATE TABLE [dbo].[HL7InboundMessage] (
    [MessageNo]                 INT            IDENTITY (-2147483648, 1) NOT FOR REPLICATION NOT NULL,
    [MessageStatus]             NCHAR (1)      NOT NULL,
    [HL7Message]                NVARCHAR (MAX) NOT NULL,
    [HL7MessageResponse]        NVARCHAR (MAX) NULL,
    [MessageSendingApplication] NVARCHAR (180) NOT NULL,
    [MessageSendingFacility]    NVARCHAR (180) NOT NULL,
    [MessageType]               NCHAR (3)      NOT NULL,
    [MessageTypeEventCode]      NCHAR (3)      NOT NULL,
    [MessageControlId]          NVARCHAR (20)  NOT NULL,
    [MessageVersion]            NVARCHAR (60)  NOT NULL,
    [MessageHeaderDate]         DATETIME       NOT NULL,
    [MessageQueuedDate]         DATETIME       NOT NULL,
    [MessageProcessedDate]      DATETIME       NULL,
    CONSTRAINT [PK_HL7InboundMessage_MessageNo] PRIMARY KEY CLUSTERED ([MessageNo] ASC) WITH (FILLFACTOR = 100)
);
GO
CREATE NONCLUSTERED INDEX [IX_HL7InboundMessage_MessageQueuedDate]
    ON [dbo].[HL7InboundMessage]([MessageQueuedDate] ASC) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_HL7InboundMessage_MessageProcessedDate]
    ON [dbo].[HL7InboundMessage]([MessageProcessedDate] ASC) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_HL7InboundMessage_MessageStatus_MessageQueuedDate_MessageProcessedDate_MessageNo]
    ON [dbo].[HL7InboundMessage]([MessageStatus] ASC, [MessageQueuedDate] ASC, [MessageProcessedDate] ASC)
    INCLUDE([MessageNo]) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7InboundMessage';

