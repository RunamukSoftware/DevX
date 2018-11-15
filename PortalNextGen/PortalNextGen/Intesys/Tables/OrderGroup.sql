CREATE TABLE [Intesys].[OrderGroup] (
    [OrderGroupID]    INT           IDENTITY (1, 1) NOT NULL,
    [NodeID]          INT           NOT NULL,
    [Rank]            INT           NOT NULL,
    [ParentNodeID]    INT           NULL,
    [NodeName]        NVARCHAR (80) NOT NULL,
    [DisplayInMenu]   TINYINT       NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_OrderGroup_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrderGroup_OrderGroupID] PRIMARY KEY CLUSTERED ([OrderGroupID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrderGroup_NodeID_ParentNodeID_NodeName]
    ON [Intesys].[OrderGroup]([NodeID] ASC, [ParentNodeID] ASC, [NodeName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the grouping of orders and how they should appear in the order index. The Order Index displays groups of USID''s and this table defines those groups.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'OrderGroup';

