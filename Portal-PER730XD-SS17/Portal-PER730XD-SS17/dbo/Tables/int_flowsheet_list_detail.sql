CREATE TABLE [dbo].[int_flowsheet_list_detail] (
    [list_detail_id] INT          NULL,
    [list_id]        INT          NULL,
    [name]           VARCHAR (30) NULL,
    [description]    VARCHAR (41) NULL,
    [seq]            INT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_flowsheet_list_detail_list_detail_id_list_id]
    ON [dbo].[int_flowsheet_list_detail]([list_detail_id] ASC, [list_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the "Valid Values" for a given field. It is the drop-down list of choices for each field. It is tied to a int_flowsheet_list record. This is the child records of a list. Every entry in the drop-down list will have a record in this table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_flowsheet_list_detail';

