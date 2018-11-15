CREATE TABLE [dbo].[PatientDevice] (
    [PatientDeviceID] BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [PatientID]       BIGINT        NOT NULL,
    [DeviceID]        BIGINT        NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_PatientDevice_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientDevice_PatientDeviceID] PRIMARY KEY NONCLUSTERED ([PatientDeviceID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [RefDevice3] FOREIGN KEY ([DeviceID]) REFERENCES [dbo].[MonitoringDevice] ([MonitoringDeviceID]),
    CONSTRAINT [RefPatient2] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientDevice_PatientID_DeviceID]
    ON [dbo].[PatientDevice]([PatientID] ASC, [DeviceID] ASC);

