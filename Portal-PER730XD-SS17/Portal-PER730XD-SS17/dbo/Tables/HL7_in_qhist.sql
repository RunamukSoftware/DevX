CREATE TABLE [dbo].[HL7_in_qhist] (
    [msg_no]           NUMERIC (10)   NOT NULL,
    [rec_id]           INT            NOT NULL,
    [msg_status]       NCHAR (1)      NOT NULL,
    [queued_dt]        DATETIME       NOT NULL,
    [outb_analyzed_dt] DATETIME       NULL,
    [HL7_text_short]   NVARCHAR (255) NULL,
    [HL7_text_long]    NTEXT          NULL,
    [processed_dt]     DATETIME       NULL,
    [processed_dur]    INT            NULL,
    [thread_id]        INT            NULL,
    [who]              NVARCHAR (20)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_HL7_in_qhist]
    ON [dbo].[HL7_in_qhist]([msg_no] ASC, [rec_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores a history of any HL/7 messages that are replayed in order to correct data issues. The HL7 services provides a mechanism to replay an HL/7 message (with changes) in order to fix data problems. This table ensures any such replays are audited.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The internal ID for the HL7 message that was replayed. FK to the HL7_in_queue table (although it may be purged from that table).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'msg_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sequence # (if replayed multiple times).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'rec_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The status of the original HL/7 message (before replaying).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'msg_status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the original HL7 message was queued. When a message is replayed, this date is updated to the new time.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'queued_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not used', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'outb_analyzed_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original HL7 message (if <= 255 characters long)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'HL7_text_short';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original HL7 message (if > 255 characters long).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'HL7_text_long';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the original message was processed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'processed_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The duration (in milliseconds) that the original HL7 message took to process.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'processed_dur';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The thread ID that the HL7 message was processed on. This is helpful for debugging.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'thread_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The person who caused the replay (either a login ID or name).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_in_qhist', @level2type = N'COLUMN', @level2name = N'who';

