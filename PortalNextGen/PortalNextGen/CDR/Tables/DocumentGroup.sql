CREATE TABLE [CDR].[DocumentGroup] (
    [DocumentGroupID] INT           IDENTITY (1, 1) NOT NULL,
    [NodeID]          INT           NULL,
    [Rank]            INT           NULL,
    [ParentNodeID]    INT           NULL,
    [NodeName]        NVARCHAR (80) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_DocumentGroup_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DocumentGroup_DocumentGroupID] PRIMARY KEY CLUSTERED ([DocumentGroupID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DocumentGroup_NodeID_Rank]
    ON [CDR].[DocumentGroup]([NodeID] ASC, [Rank] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines a grouping of documents for document imaging. A site defines a "tree" structure that documents are mapped into. This table defines that tree.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'DocumentGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A system assigned random ID for this node.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'DocumentGroup', @level2type = N'COLUMN', @level2name = N'NodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Defines the order of the nodes in the tree. They are loaded in this order.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'DocumentGroup', @level2type = N'COLUMN', @level2name = N'Rank';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Defines the parent node for this node. If NULL this is a root level node. (can have multiple root level nodes).', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'DocumentGroup', @level2type = N'COLUMN', @level2name = N'ParentNodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name that is displayed in the tree.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'DocumentGroup', @level2type = N'COLUMN', @level2name = N'NodeName';

