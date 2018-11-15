CREATE TABLE [dbo].[cdr_document_group] (
    [node_id]        INT           NULL,
    [rank]           INT           NULL,
    [parent_node_id] INT           NULL,
    [node_name]      NVARCHAR (80) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_cdr_document_group_node_id_rank]
    ON [dbo].[cdr_document_group]([node_id] ASC, [rank] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines a grouping of documents for document imaging. A site defines a "tree" structure that documents are mapped into. This table defines that tree.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_document_group';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A system assigned random ID for this node.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_document_group', @level2type = N'COLUMN', @level2name = N'node_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Defines the order of the nodes in the tree. They are loaded in this order.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_document_group', @level2type = N'COLUMN', @level2name = N'rank';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Defines the parent node for this node. If NULL this is a root level node. (can have multiple root level nodes).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_document_group', @level2type = N'COLUMN', @level2name = N'parent_node_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name that is displayed in the tree.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_document_group', @level2type = N'COLUMN', @level2name = N'node_name';

