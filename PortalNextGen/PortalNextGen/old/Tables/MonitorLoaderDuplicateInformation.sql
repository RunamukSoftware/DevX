CREATE TABLE [old].[MonitorLoaderDuplicateInformation] (
    [MonitorLoaderDuplicateInformationID] INT           IDENTITY (1, 1) NOT NULL,
    [OriginalID]                          VARCHAR (20)  NOT NULL,
    [DuplicateID]                         VARCHAR (20)  NOT NULL,
    [OriginalMonitor]                     VARCHAR (5)   NOT NULL,
    [DuplicateMonitor]                    VARCHAR (5)   NOT NULL,
    [InsertDateTime]                      DATETIME2 (7) CONSTRAINT [DF_MonitorLoaderDuplicateInformation_InsertDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedDateTime]                     DATETIME2 (7) CONSTRAINT [DF_MonitorLoaderDuplicateInformation_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MonitorLoaderDuplicateInformation_MonitorLoaderDuplicateInformationID] PRIMARY KEY CLUSTERED ([MonitorLoaderDuplicateInformationID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'MonitorLoaderDuplicateInformation';

