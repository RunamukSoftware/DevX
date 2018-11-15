CREATE TABLE [dbo].[HL7_msg_list] (
    [list_name] NVARCHAR (20) NOT NULL,
    [msg_no]    INT           NOT NULL,
    [seq]       INT           NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_HL7_msg_list_list_name_seq_msg_no]
    ON [dbo].[HL7_msg_list]([list_name] ASC, [seq] ASC, [msg_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table allows the creation of temporary "lists" of HL7 messages. The DataLoader can then be configured to only process a certain list. This is usefull for debugging DataLoaders, since DataLoaders normally process all unprocessed messages in the order they were queued.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_list';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A name assigned to this list. This is the value that is passed to the DataLoader to only process a certain list.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_list', @level2type = N'COLUMN', @level2name = N'list_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The msg_no in the HL7_in_queue table that is part of this list.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_list', @level2type = N'COLUMN', @level2name = N'msg_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sequence # (starting at 1) of this HL7 message within a list. The DataLoader processes them according to this sequence.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7_msg_list', @level2type = N'COLUMN', @level2name = N'seq';

