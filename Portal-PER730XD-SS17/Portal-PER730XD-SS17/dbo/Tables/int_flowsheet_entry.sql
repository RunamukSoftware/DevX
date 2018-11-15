CREATE TABLE [dbo].[int_flowsheet_entry] (
    [flowsheet_entry_id]  UNIQUEIDENTIFIER NULL,
    [test_cid]            INT              NULL,
    [data_type]           NVARCHAR (50)    NULL,
    [select_list_id]      INT              NULL,
    [units]               NVARCHAR (50)    NULL,
    [normal_float]        FLOAT (53)       NULL,
    [absolute_float_high] FLOAT (53)       NULL,
    [absolute_float_low]  FLOAT (53)       NULL,
    [warning_float_high]  FLOAT (53)       NULL,
    [warning_float_low]   FLOAT (53)       NULL,
    [critical_float_high] FLOAT (53)       NULL,
    [critical_float_low]  FLOAT (53)       NULL,
    [normal_int]          INT              NULL,
    [absolute_int_high]   INT              NULL,
    [absolute_int_low]    INT              NULL,
    [warning_int_high]    INT              NULL,
    [warning_int_low]     INT              NULL,
    [critical_int_high]   INT              NULL,
    [critical_int_low]    INT              NULL,
    [normal_string]       NVARCHAR (50)    NULL,
    [max_length]          INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_flowsheet_entry_flowsheet_entry_id]
    ON [dbo].[int_flowsheet_entry]([flowsheet_entry_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to control validation of each field (for data entry). It is used in conjunction with the int_flowsheet_detail table to drive the display/input logic.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_flowsheet_entry';

