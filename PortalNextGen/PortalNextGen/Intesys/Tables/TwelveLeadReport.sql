CREATE TABLE [Intesys].[TwelveLeadReport] (
    [ReportID]          INT             NOT NULL,
    [PatientID]         INT             NOT NULL,
    [OriginalPatientID] INT             NULL,
    [MonitorID]         INT             NOT NULL,
    [ReportNumber]      INT             NOT NULL,
    [ReportDateTime]    DATETIME2 (7)   NOT NULL,
    [ExportSwitch]      BIT             NOT NULL,
    [ReportData]        VARBINARY (MAX) NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_TwelveLeadReport_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TwelveLeadReport_ReportID_PatientID] PRIMARY KEY CLUSTERED ([ReportID] ASC, [PatientID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_TwelveLeadReport_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_TwelveLeadReport_reportDateTime]
    ON [Intesys].[TwelveLeadReport]([ReportDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the 12 lead reports collected from the monitor. Each record is uniquely identified by the reportID. The data in this table is populated by the monitor loader process.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying a 12 lead report.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'ReportID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying a patient. Foreign key to the int_patient table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Original patient ID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The monitor ID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'MonitorID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Report sequence number used along with PatientID and report_dt to create unique ID for 12-Leads reports', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'ReportNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time of the 12 lead report.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'ReportDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether the report is active or not(?!?)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'ExportSwitch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The 12 lead report data.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReport', @level2type = N'COLUMN', @level2name = N'ReportData';

