CREATE TABLE [Intesys].[PrintJob] (
    [PrintJobID]          INT             IDENTITY (1, 1) NOT NULL,
    [PageNumber]          INT             NOT NULL,
    [PatientID]           INT             NOT NULL,
    [OriginalPatientID]   INT             NULL,
    [JobNetDateTime]      DATETIME2 (7)   NOT NULL,
    [Description]         NVARCHAR (120)  NOT NULL,
    [DataNode]            INT             NOT NULL,
    [SweepSpeed]          FLOAT (53)      NOT NULL,
    [Duration]            FLOAT (53)      NOT NULL,
    [NumberOfChannels]    INT             NOT NULL,
    [AlarmID]             INT             NOT NULL,
    [JobType]             VARCHAR (25)    NOT NULL,
    [Title]               VARCHAR (120)   NOT NULL,
    [Bed]                 VARCHAR (25)    NOT NULL,
    [RecordingTime]       VARCHAR (25)    NOT NULL,
    [ByteHeight]          INT             NOT NULL,
    [BitmapHeight]        INT             NOT NULL,
    [BitmapWidth]         INT             NOT NULL,
    [Scale]               INT             NOT NULL,
    [Annotation1]         VARCHAR (120)   NOT NULL,
    [Annotation2]         VARCHAR (120)   NOT NULL,
    [Annotation3]         VARCHAR (120)   NOT NULL,
    [Annotation4]         VARCHAR (120)   NOT NULL,
    [PrintBitmap]         VARBINARY (MAX) NOT NULL,
    [TwelveLeadData]      VARBINARY (MAX) NOT NULL,
    [EndOfJobSwitch]      BIT             NOT NULL,
    [PrintSwitch]         BIT             NOT NULL,
    [PrinterName]         VARCHAR (255)   NOT NULL,
    [LastPrintedDateTime] DATETIME2 (7)   NOT NULL,
    [StatusCode]          CHAR (1)        NOT NULL,
    [StatusMessage]       VARCHAR (500)   NOT NULL,
    [StartRecord]         VARBINARY (MAX) NOT NULL,
    [RowDateTime]         SMALLDATETIME   CONSTRAINT [DF_PrintJob_RowDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowID]               INT             CONSTRAINT [DF_PrintJob_RowID] DEFAULT ((0)) NOT NULL,
    [CreatedDateTime]     DATETIME2 (7)   CONSTRAINT [DF_PrintJob_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintJob_PrintJobID] PRIMARY KEY CLUSTERED ([PrintJobID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintJob_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [PK_PrintJob_RowDateTime_RowID]
    ON [Intesys].[PrintJob]([RowDateTime] ASC, [RowID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJob_PrintSwitch_PrintJobID_PageNumber_JobNetDateTime_EndOfJobSwitch]
    ON [Intesys].[PrintJob]([PrintSwitch] ASC)
    INCLUDE([PrintJobID], [PageNumber], [JobNetDateTime], [EndOfJobSwitch]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the printing job information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PrintJob';

