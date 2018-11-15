CREATE TABLE [dbo].[DeviceParameter] (
    [DeviceParameterID] BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [DeviceID]          BIGINT        NOT NULL,
    [ParameterID]       BIGINT        NOT NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_DeviceParameter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DeviceParameter_DeviceParameterID] PRIMARY KEY CLUSTERED ([DeviceParameterID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_DeviceParameter_MonitoringDevice_MonitoringDeviceID] FOREIGN KEY ([DeviceID]) REFERENCES [dbo].[MonitoringDevice] ([MonitoringDeviceID]),
    CONSTRAINT [FK_DeviceParameter_Parameter_ParameterID] FOREIGN KEY ([ParameterID]) REFERENCES [dbo].[Parameter] ([ParameterID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DeviceParameter_DeviceID_ParameterID]
    ON [dbo].[DeviceParameter]([DeviceID] ASC, [ParameterID] ASC);

