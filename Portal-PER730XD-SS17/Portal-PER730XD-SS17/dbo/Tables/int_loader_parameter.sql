CREATE TABLE [dbo].[int_loader_parameter] (
    [msg_event_code] CHAR (3)         NULL,
    [sys_id]         UNIQUEIDENTIFIER NULL,
    [code_id]        INT              NULL,
    [parm]           NVARCHAR (30)    NULL,
    [value]          NVARCHAR (80)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_loader_parameter_msg_event_code_sys_id_code_id_parm_value]
    ON [dbo].[int_loader_parameter]([msg_event_code] ASC, [sys_id] ASC, [code_id] ASC, [parm] ASC, [value] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all parameters used to control the HL/7 loader. A site can customize the behavior of the Loader by adding/modifying values in this table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_loader_parameter';

