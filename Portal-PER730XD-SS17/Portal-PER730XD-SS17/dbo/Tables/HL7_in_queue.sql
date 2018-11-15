CREATE TABLE [dbo].[HL7_in_queue] (
    [msg_no]           NUMERIC (10)   IDENTITY (0, 1) NOT NULL,
    [msg_status]       NCHAR (1)      CONSTRAINT [DF_HL7_in_queue_msg_status] DEFAULT ('N') NOT NULL,
    [queued_dt]        DATETIME       NOT NULL,
    [outb_analyzed_dt] DATETIME       NULL,
    [msh_msg_type]     NCHAR (3)      NOT NULL,
    [msh_event_cd]     NCHAR (3)      NOT NULL,
    [msh_organization] NVARCHAR (36)  NOT NULL,
    [msh_system]       NVARCHAR (36)  NOT NULL,
    [msh_dt]           DATETIME       NOT NULL,
    [msh_control_id]   NVARCHAR (36)  NOT NULL,
    [msh_ack_cd]       NCHAR (2)      NULL,
    [msh_version]      NVARCHAR (5)   NOT NULL,
    [pid_mrn]          NVARCHAR (20)  NULL,
    [pv1_visit_no]     NVARCHAR (50)  NULL,
    [patient_id]       NUMERIC (10)   NULL,
    [HL7_text_short]   NVARCHAR (255) NULL,
    [HL7_text_long]    NTEXT          NULL,
    [processed_dt]     DATETIME       NULL,
    [processed_dur]    INT            NULL,
    [thread_id]        INT            NULL,
    [who]              NVARCHAR (20)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_HL7_in_queue_msg_no]
    ON [dbo].[HL7_in_queue]([msg_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is the primary queuing table for inbound HL/7 messages. All messages that are destined for any Intesys product are stored in this table. The message is originally inserted into this table with a status of "N" (not read) and later the DataLoader takes the message and does the real work of parsing it and storing the data in the appropriate tables. If it succeeds, then it changes the status to "R" (read), otherwise it flags it with a status of "E" (error). Note: Usually sites are configured to purge all successful ("R") messages after several weeks. Keeping all HL/7 messages indefinitely is generally not practical.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A system generated number for this HL7 message. This number is incremented and guarantees that if sorted ascending, you will get the messages in the same order received from the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msg_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A status that represents the current state of this message. "N" = Not Read (not processed by loader yet) "R" = Processed by loader and no errors "E" = Processed by loader and error(s) occurred "any other value" = Ignored by loader', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msg_status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time that this message was inserted into this table (within milliseconds of receiving it in the communicator).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'queued_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not used.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'outb_analyzed_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Message Type in the MSH segment (ADT, ORU, etc) . Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_msg_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The event code in the MSH segment (A08, R01, etc). Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_event_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sending organization (the organization in the MSH segment). Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_organization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sending system (The sending system in the MSH segment) Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_system';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time of the message (DateTime in the MSH segment). Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The control ID (Number that the external system identifies this message by). Control ID in the MSH segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_control_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The ACK code in the MSH segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_ack_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Version field in the MSH segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'msh_version';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The MRN field in the PID segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'pid_mrn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Visit Number field in the PV1 segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'pv1_visit_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient ID in the PID segment. Parsed out by the communicator.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The actual HL7 message (if <= 255 characters)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'HL7_text_short';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The actual HL7 message (if > 255 characters)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'HL7_text_long';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the DataLoader finished processing a message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'processed_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The # milliseconds that the DataLoader took to process this message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'processed_dur';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The thread # within the DataLoader that processed this message. It is generally a requirement that all messages for a given patient get processed in the same thread (otherwise they may get processed out of order).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'thread_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not used.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_queue', @level2type = N'COLUMN', @level2name = N'who';

