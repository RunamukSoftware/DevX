CREATE TABLE [ICS].[AcquisitionModule] (
    [AcquisitionModuleID] INT           NOT NULL,
    [Name]                VARCHAR (50)  NOT NULL,
    [Description]         VARCHAR (50)  NOT NULL,
    [MonitoringDeviceID]  INT           NOT NULL,
    [ParameterID]         INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_AcquisitionModule_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AcquisitionModule_AcquisitionModuleID] PRIMARY KEY CLUSTERED ([AcquisitionModuleID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AcquisitionModule_MonitoringDevice_MonitoringDeviceID] FOREIGN KEY ([MonitoringDeviceID]) REFERENCES [ICS].[MonitoringDevice] ([MonitoringDeviceID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'AcquisitionModule';

