CREATE TABLE [ICS].[MonitoringDevice] (
    [MonitoringDeviceID] INT           NOT NULL,
    [Name]               VARCHAR (50)  NOT NULL,
    [Description]        VARCHAR (50)  NOT NULL,
    [Room]               VARCHAR (12)  NOT NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_MonitoringDevice_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MonitoringDevice_MonitoringDeviceID] PRIMARY KEY CLUSTERED ([MonitoringDeviceID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'MonitoringDevice';

