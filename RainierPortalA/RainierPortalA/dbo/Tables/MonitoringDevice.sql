CREATE TABLE [dbo].[MonitoringDevice] (
    [MonitoringDeviceID] BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [Name]               VARCHAR (255) NOT NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_MonitoringDevice_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MonitoringDevice_MonitoringDeviceID] PRIMARY KEY CLUSTERED ([MonitoringDeviceID] ASC) WITH (FILLFACTOR = 100)
);

