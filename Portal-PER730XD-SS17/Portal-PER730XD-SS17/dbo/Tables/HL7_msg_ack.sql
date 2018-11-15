CREATE TABLE [dbo].[HL7_msg_ack] (
    [msg_control_id]     NCHAR (20)    NOT NULL,
    [msg_status]         NCHAR (10)    NOT NULL,
    [clientIP]           NCHAR (30)    NOT NULL,
    [ack_msg_control_id] NCHAR (20)    NULL,
    [ack_system]         NCHAR (50)    NULL,
    [ack_organization]   NCHAR (50)    NULL,
    [received_dt]        DATETIME      NULL,
    [notes]              NVARCHAR (80) NULL,
    [num_retries]        INT           NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ndx_pkey]
    ON [dbo].[HL7_msg_ack]([msg_control_id] ASC, [clientIP] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table keeps tracks of information from which client valid ACK was received on previously send outbound message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Message control id included in outbound messages.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'msg_control_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This information indicates if valid ACK message was received from the client. The status can be R or E.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'msg_status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column indicates IP address of client to whom outbound message was send and from whom ACK should be received.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'clientIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column defines ACK message control id.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'ack_msg_control_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column contains information on Sending Application from ACK message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'ack_system';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column contains information on Sending Facility from ACK message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'ack_organization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column indicates the DateTime ACK message was received from client system.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'received_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field is not in use.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This information indicates how many from user-defined time message was sent to the client (error case).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_ack', @level2type = N'COLUMN', @level2name = N'num_retries';

