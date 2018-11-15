CREATE TABLE [Intesys].[TwelveLeadReportEdit] (
    [TwelveLeadReportEditID] INT           IDENTITY (1, 1) NOT NULL,
    [ReportID]               INT           NOT NULL,
    [InsertDateTime]         DATETIME2 (7) NOT NULL,
    [UserID]                 INT           NULL,
    [version_number]         SMALLINT      NULL,
    [patient_name]           VARCHAR (80)  NULL,
    [report_date]            VARCHAR (80)  NULL,
    [report_time]            VARCHAR (80)  NULL,
    [id_number]              VARCHAR (80)  NULL,
    [birthdate]              VARCHAR (80)  NULL,
    [age]                    VARCHAR (80)  NULL,
    [sex]                    VARCHAR (80)  NULL,
    [height]                 VARCHAR (80)  NULL,
    [weight]                 VARCHAR (80)  NULL,
    [ventRate]               INT           NULL,
    [pr_interval]            INT           NULL,
    [qt]                     INT           NULL,
    [qtc]                    INT           NULL,
    [qrsDuration]            INT           NULL,
    [p_axis]                 INT           NULL,
    [qrs_axis]               INT           NULL,
    [t_axis]                 INT           NULL,
    [interpretation]         VARCHAR (MAX) NULL,
    [CreatedDateTime]        DATETIME2 (7) CONSTRAINT [DF_TwelveLeadReportEdit_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TwelveLeadReportEdit_TwelveLeadReportEditID] PRIMARY KEY CLUSTERED ([TwelveLeadReportEditID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_TwelveLeadReportEdit_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TwelveLeadReportEdit_ReportID_InsertDateTime_UserID]
    ON [Intesys].[TwelveLeadReportEdit]([ReportID] ASC, [InsertDateTime] ASC, [UserID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores 12-lead report text edits. Each record is uniquely identified by the reportID and InsertDateTime. The data in this table is populated by the patsrv process. New records are added and no records are deleted.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying a 12-lead report.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'ReportID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the row was inserted into the table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'InsertDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying the user who added the 12-lead report edits', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The version number of the 12-lead report edits.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'version_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name of the patient on the 12-lead report.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'patient_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Report date.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'report_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Report time.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'report_time';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient MedicalRecordNumber (MRN).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'id_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient birthdate.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'birthdate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient age.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'age';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient sex.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'sex';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient height.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'height';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient weight.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'weight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ventilation rate.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'ventRate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PR interval for heart rate', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'pr_interval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QT interval for heart rate', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'qt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QT interval corrected for heart rate', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'qtc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QRS duration for heart rate.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'qrsDuration';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P-axis for heart rate.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'p_axis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QRS-axis for heart rate.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'qrs_axis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'T-axis for heart rate.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N't_axis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportEdit', @level2type = N'COLUMN', @level2name = N'interpretation';

