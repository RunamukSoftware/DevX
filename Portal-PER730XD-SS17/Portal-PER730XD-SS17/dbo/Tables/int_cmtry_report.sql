CREATE TABLE [dbo].[int_cmtry_report] (
    [patient_id]      UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [report_name]     NVARCHAR (50)    NOT NULL,
    [report_data]     IMAGE            NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_cmtry_report_patient_id_report_name]
    ON [dbo].[int_cmtry_report]([patient_id] ASC, [report_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_cmtry_report';

