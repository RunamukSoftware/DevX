CREATE TABLE [HL7].[MessageAcknowledgement] (
    [MessageAcknowledgementID]        INT           IDENTITY (1, 1) NOT NULL,
    [MessageControlID]                NVARCHAR (20) NOT NULL,
    [MessageStatus]                   CHAR (1)      NOT NULL,
    [ClientIP]                        NVARCHAR (30) NOT NULL,
    [AcknowledgementMessageControlID] NVARCHAR (20) NULL,
    [AcknowledgementSystem]           NVARCHAR (50) NULL,
    [AcknowledgementOrganization]     NVARCHAR (50) NULL,
    [ReceivedDateTime]                DATETIME2 (7) NULL,
    [Notes]                           NVARCHAR (80) NULL,
    [NumberOfRetries]                 INT           NULL,
    [CreatedDateTime]                 DATETIME2 (7) CONSTRAINT [DF_MessageAcknowledgement_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MessageAcknowledgement_MessageAcknowledgementID] PRIMARY KEY CLUSTERED ([MessageAcknowledgementID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MessageAcknowledgement_MessageControlID_ClientIP]
    ON [HL7].[MessageAcknowledgement]([MessageControlID] ASC, [ClientIP] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table keeps tracks of information from which client valid ACK was received on previously send outbound message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Message control id included in outbound messages.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'MessageControlID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This information indicates if valid ACK message was received from the client. The status can be R or E.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'MessageStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column indicates IP address of client to whom outbound message was send and from whom ACK should be received.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'ClientIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column defines ACK message control id.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'AcknowledgementMessageControlID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column contains information on Sending Application from ACK message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'AcknowledgementSystem';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column contains information on Sending Facility from ACK message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'AcknowledgementOrganization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column indicates the DateTime ACK message was received from client system.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'ReceivedDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field is not in use.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This information indicates how many from user-defined time message was sent to the client (error case).', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageAcknowledgement', @level2type = N'COLUMN', @level2name = N'NumberOfRetries';

