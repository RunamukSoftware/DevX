CREATE TABLE [dbo].[int_12lead_report_edit] (
    [report_id]      UNIQUEIDENTIFIER NOT NULL,
    [insert_dt]      DATETIME         NOT NULL,
    [user_id]        UNIQUEIDENTIFIER NULL,
    [version_number] SMALLINT         NULL,
    [patient_name]   VARCHAR (80)     NULL,
    [report_date]    VARCHAR (80)     NULL,
    [report_time]    VARCHAR (80)     NULL,
    [id_number]      VARCHAR (80)     NULL,
    [birthdate]      VARCHAR (80)     NULL,
    [age]            VARCHAR (80)     NULL,
    [sex]            VARCHAR (80)     NULL,
    [height]         VARCHAR (80)     NULL,
    [weight]         VARCHAR (80)     NULL,
    [vent_rate]      INT              NULL,
    [pr_interval]    INT              NULL,
    [qt]             INT              NULL,
    [qtc]            INT              NULL,
    [qrs_duration]   INT              NULL,
    [p_axis]         INT              NULL,
    [qrs_axis]       INT              NULL,
    [t_axis]         INT              NULL,
    [interpretation] TEXT             NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_12lead_report_edit_report_id_insert_dt_user_id]
    ON [dbo].[int_12lead_report_edit]([report_id] ASC, [insert_dt] ASC, [user_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores 12-lead report text edits. Each record is uniquely identified by the report_id and insert_dt. The data in this table is populated by the patsrv process. New records are added and no records are deleted.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying a 12-lead report.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'report_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the row was inserted into the table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'insert_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying the user who added the 12-lead report edits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The version number of the 12-lead report edits.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'version_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name of the patient on the 12-lead report.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'patient_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Report date.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'report_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Report time.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'report_time';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient MRN.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'id_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient birthdate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'birthdate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient age.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'age';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient sex.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'sex';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient height.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'height';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient weight.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'weight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ventilation rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'vent_rate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PR interval for heart rate', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'pr_interval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QT interval for heart rate', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'qt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QT interval corrected for heart rate', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'qtc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QRS duration for heart rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'qrs_duration';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P-axis for heart rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'p_axis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QRS-axis for heart rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'qrs_axis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'T-axis for heart rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N't_axis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_edit', @level2type = N'COLUMN', @level2name = N'interpretation';

