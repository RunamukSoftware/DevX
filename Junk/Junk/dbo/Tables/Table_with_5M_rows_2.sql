CREATE TABLE [dbo].[Table_with_5M_rows] (
    [OrderItemID] BIGINT         NOT NULL,
    [OrderID]     INT            NULL,
    [Price]       INT            NULL,
    [ProductName] NVARCHAR (103) NOT NULL
);


GO
CREATE CLUSTERED COLUMNSTORE INDEX [CL_Table_with_5M_rows_ColumnStore]
    ON [dbo].[Table_with_5M_rows];

