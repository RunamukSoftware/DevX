CREATE TABLE [dbo].[int_system_parameter] (
    [system_parameter_id] INT            NOT NULL,
    [name]                NVARCHAR (30)  NOT NULL,
    [parm_value]          NVARCHAR (80)  NULL,
    [active_flag]         TINYINT        NULL,
    [after_discharge_sw]  TINYINT        NULL,
    [debug_sw]            TINYINT        NULL,
    [descr]               NVARCHAR (255) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_system_parameter_system_parameter_id]
    ON [dbo].[int_system_parameter]([system_parameter_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the parameters for system processes such as number of days past admit/discharge date for trimming pre-admit/inpatient visits OR table name, index name for dbcc/update stats process. It stores parameters that are used by system processes (backend services).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_system_parameter';

