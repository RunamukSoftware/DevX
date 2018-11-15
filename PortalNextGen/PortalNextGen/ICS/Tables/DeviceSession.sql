CREATE TABLE [ICS].[DeviceSession] (
    [DeviceSessionID]    INT           NOT NULL,
    [EncounterID]        INT           NOT NULL,
    [MonitoringDeviceID] INT           NOT NULL,
    [BeginDateTime]      DATETIME2 (7) NOT NULL,
    [EndDateTime]        DATETIME2 (7) NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_DeviceSession_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DeviceSession_DeviceSessionID] PRIMARY KEY CLUSTERED ([DeviceSessionID] ASC),
    CONSTRAINT [FK_DeviceSession_Encounter_EncounterID] FOREIGN KEY ([DeviceSessionID]) REFERENCES [ICS].[Encounter] ([EncounterID]),
    CONSTRAINT [FK_DeviceSession_MonitoringDevice_MonitoringDeviceID] FOREIGN KEY ([MonitoringDeviceID]) REFERENCES [ICS].[MonitoringDevice] ([MonitoringDeviceID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Device session', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'DeviceSession';

