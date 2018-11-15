CREATE TABLE [dbo].[AcquistionModule] (
    [AcquistionModuleID] INT           NOT NULL,
    [MonitoringDeviceID] BIGINT        NOT NULL,
    [CreatedDateTime]    DATETIME2 (7) DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AcquistionModule_AcquistionModuleID] PRIMARY KEY CLUSTERED ([AcquistionModuleID] ASC),
    CONSTRAINT [FK_AcquistionModule_MonitoringDevice_MonitoringDeviceID] FOREIGN KEY ([MonitoringDeviceID]) REFERENCES [dbo].[MonitoringDevice] ([MonitoringDeviceID])
);

