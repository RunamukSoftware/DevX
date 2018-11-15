CREATE TABLE [Intesys].[TwelveLeadReportNew] (
    [PatientID]           INT             NOT NULL,
    [ReportID]            INT             NOT NULL,
    [ReportDateTime]      DATETIME2 (7)   NOT NULL,
    [VersionNumber]       SMALLINT        NOT NULL,
    [PatientName]         NVARCHAR (50)   NOT NULL,
    [IDNumber]            NVARCHAR (20)   NOT NULL,
    [BirthDate]           DATE            NOT NULL,
    [Age]                 NVARCHAR (15)   NOT NULL,
    [Gender]              NCHAR (1)       NOT NULL,
    [Height]              NVARCHAR (15)   NOT NULL,
    [Weight]              NVARCHAR (15)   NOT NULL,
    [VentRate]            INT             NOT NULL,
    [PrInterval]          INT             NOT NULL,
    [Qt]                  INT             NOT NULL,
    [Qtc]                 INT             NOT NULL,
    [QrsDuration]         INT             NOT NULL,
    [PAxis]               INT             NOT NULL,
    [QrsAxis]             INT             NOT NULL,
    [TAxis]               INT             NOT NULL,
    [Interpretation]      NVARCHAR (MAX)  NOT NULL,
    [SampleRate]          INT             NOT NULL,
    [SampleCount]         INT             NOT NULL,
    [NumberOfYPoints]     INT             NOT NULL,
    [Baseline]            INT             NOT NULL,
    [YPointsPerUnit]      INT             NOT NULL,
    [WaveformData]        VARBINARY (MAX) NOT NULL,
    [SendRequest]         SMALLINT        NOT NULL,
    [SendComplete]        SMALLINT        NOT NULL,
    [SendDateTime]        DATETIME2 (7)   NOT NULL,
    [InterpretationEdits] NVARCHAR (MAX)  NOT NULL,
    [UserID]              INT             NOT NULL,
    [CreatedDateTime]     DATETIME2 (7)   CONSTRAINT [DF_TwelveLeadReportNew_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TwelveLeadReportNew_PatientID_ReportID] PRIMARY KEY CLUSTERED ([PatientID] ASC, [ReportID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_TwelveLeadReportNew_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_TwelveLeadReportNew_TwelveLeadReport_ReportID_PatientID] FOREIGN KEY ([ReportID], [PatientID]) REFERENCES [Intesys].[TwelveLeadReport] ([ReportID], [PatientID]),
    CONSTRAINT [FK_TwelveLeadReportNew_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains 12-lead demographics, measurements, interpretation, and waveform data. The int_report column matches that in the int_12lead_report table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TwelveLeadReportNew';

