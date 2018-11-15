CREATE TABLE [HL7].[MessageList] (
    [MessageListID]   INT           IDENTITY (1, 1) NOT NULL,
    [ListName]        NVARCHAR (20) NOT NULL,
    [MessageNumber]   INT           NOT NULL,
    [Sequence]        INT           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_MessageList_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MessageList_MessageListID] PRIMARY KEY CLUSTERED ([MessageListID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MessageList_ListName_Sequence_MessageNumber]
    ON [HL7].[MessageList]([ListName] ASC, [Sequence] ASC, [MessageNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table allows the creation of temporary "lists" of HL7 messages. The DataLoader can then be configured to only process a certain list. This is usefull for debugging DataLoaders, since DataLoaders normally process all unprocessed messages in the order they were queued.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A name assigned to this list. This is the value that is passed to the DataLoader to only process a certain list.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'ListName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The MessageNumber in the HL7_in_queue table that is part of this list.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'MessageNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sequence number (starting at 1) of this HL7 message within a list. The DataLoader processes them according to this sequence.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'Sequence';

