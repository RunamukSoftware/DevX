CREATE TABLE [dbo].[int_order_group_detail] (
    [node_id]      INT      NOT NULL,
    [univ_svc_cid] INT      NULL,
    [rank]         INT      NOT NULL,
    [display_type] CHAR (5) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_order_group_detail_node_id_rank]
    ON [dbo].[int_order_group_detail]([node_id] ASC, [rank] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is a detail table for the int_order_group table. It defines the USID''s that belong to a given order group. A USID can appear in multiple order groups.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_order_group_detail';

