CREATE TABLE [dbo].[int_flowsheet_list] (
    [list_id]            INT          NULL,
    [name]               VARCHAR (30) NULL,
    [description]        VARCHAR (41) NULL,
    [allow_multi_select] TINYINT      NULL,
    [allow_free_text]    TINYINT      NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_flowsheet_list_list_id]
    ON [dbo].[int_flowsheet_list]([list_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the list of drop-down fields. It is the parent record for the int_flowsheet_list_detail table. There will be one record in this table for every drop-down (and one row in int_flowsheet_list_detail for every item in the drop-down).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_flowsheet_list';

