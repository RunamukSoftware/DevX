CREATE TABLE [dbo].[int_flowsheet_detail] (
    [flowsheet_detail_id] UNIQUEIDENTIFIER NULL,
    [flowsheet_id]        UNIQUEIDENTIFIER NULL,
    [name]                NVARCHAR (80)    NULL,
    [detail_type]         NVARCHAR (50)    NULL,
    [parent_id]           UNIQUEIDENTIFIER NULL,
    [seq]                 INT              NULL,
    [test_cid]            INT              NULL,
    [show_only_when_data] TINYINT          NULL,
    [is_compressed]       TINYINT          NULL,
    [is_visible]          TINYINT          NULL,
    [flowsheet_entry_id]  UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_flowsheet_detail_flowsheet_id_test_cid]
    ON [dbo].[int_flowsheet_detail]([flowsheet_id] ASC, [test_cid] ASC, [flowsheet_detail_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines what tests and results should show on a given flowsheet. It is the detail table for the int_flowsheet table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_flowsheet_detail';

