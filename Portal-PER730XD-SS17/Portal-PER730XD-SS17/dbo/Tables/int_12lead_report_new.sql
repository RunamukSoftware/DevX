CREATE TABLE [dbo].[int_12lead_report_new] (
    [patient_id]           UNIQUEIDENTIFIER NOT NULL,
    [report_id]            UNIQUEIDENTIFIER NOT NULL,
    [report_dt]            DATETIME         NOT NULL,
    [version_number]       SMALLINT         NULL,
    [patient_name]         NVARCHAR (50)    NULL,
    [id_number]            NVARCHAR (20)    NULL,
    [birthdate]            NVARCHAR (15)    NULL,
    [age]                  NVARCHAR (15)    NULL,
    [sex]                  NVARCHAR (1)     NULL,
    [height]               NVARCHAR (15)    NULL,
    [weight]               NVARCHAR (15)    NULL,
    [report_date]          NVARCHAR (15)    NULL,
    [report_time]          NVARCHAR (15)    NULL,
    [vent_rate]            INT              NULL,
    [pr_interval]          INT              NULL,
    [qt]                   INT              NULL,
    [qtc]                  INT              NULL,
    [qrs_duration]         INT              NULL,
    [p_axis]               INT              NULL,
    [qrs_axis]             INT              NULL,
    [t_axis]               INT              NULL,
    [interpretation]       NTEXT            NULL,
    [sample_rate]          INT              NOT NULL,
    [sample_count]         INT              NOT NULL,
    [num_Ypoints]          INT              NOT NULL,
    [baseline]             INT              NOT NULL,
    [Ypoints_per_unit]     INT              NOT NULL,
    [waveform_data]        IMAGE            NULL,
    [send_request]         SMALLINT         NULL,
    [send_complete]        SMALLINT         NULL,
    [send_dt]              DATETIME         NULL,
    [interpretation_edits] NTEXT            NULL,
    [user_id]              UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_int_12lead_report_new_patient_id_report_id] PRIMARY KEY CLUSTERED ([patient_id] ASC, [report_id] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_12lead_report_new_12lead_report_int_report_id_patient_id] FOREIGN KEY ([report_id], [patient_id]) REFERENCES [dbo].[int_12lead_report] ([report_id], [patient_id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains 12-lead demographics, measurements, interpretation, and waveform data. The int_report column matches that in the int_12lead_report table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_12lead_report_new';

