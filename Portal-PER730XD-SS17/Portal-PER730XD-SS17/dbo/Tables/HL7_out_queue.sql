CREATE TABLE [dbo].[HL7_out_queue] (
    [msg_status]       NCHAR (10)     NOT NULL,
    [msg_no]           CHAR (20)      NOT NULL,
    [HL7_text_long]    NTEXT          NULL,
    [HL7_text_short]   NVARCHAR (255) NULL,
    [patient_id]       NVARCHAR (60)  NULL,
    [msh_system]       NVARCHAR (50)  NOT NULL,
    [msh_organization] NVARCHAR (50)  NOT NULL,
    [msh_event_cd]     NCHAR (10)     NOT NULL,
    [msh_msg_type]     NCHAR (10)     NOT NULL,
    [sent_dt]          DATETIME       NULL,
    [queued_dt]        DATETIME       NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_HL7_out_queue_msg_no]
    ON [dbo].[HL7_out_queue]([msg_no] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_HL7_out_queue_queued_dt]
    ON [dbo].[HL7_out_queue]([queued_dt] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_HL7_out_queue_sent_dt]
    ON [dbo].[HL7_out_queue]([sent_dt] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is a queue for outbound HL/7 messages. Any messages that are being sent to another system are first copied here. Once they are sent, the status of the message is changed. A batch process can remove rows from here once messages are sent.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The status of the outbound HL/7 message (whether it has been sent or not) "N" = not sent yet "R" = sent "E" = error sending message', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'msg_status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A system generated number for this message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'msg_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If an HL/7 message is more than 255 chars, then this represents the complete HL/7 message (most will be in here).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'HL7_text_long';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If the HL/7 message is less than 255 chars, then the message is stored here.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'HL7_text_short';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the patient table. This is the patient this message was generated for.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sending system that is in the MSH of the outbound message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'msh_system';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Organization identifier used in the MSH of the outbound message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'msh_organization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HL/7 event code of this message (ex: A01, R01, etc).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'msh_event_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This higher-level type of message (ex: ADT, ORU).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'msh_msg_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the message was successfully sent to the receiver.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'sent_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time this HL/7 message was inserted into this table. Depending on the polling cycle and how backed up the receiver is, it may be a while before it is actually sent.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_out_queue', @level2type = N'COLUMN', @level2name = N'queued_dt';

