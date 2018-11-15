CREATE TABLE [old].[DeviceSession] (
    [DeviceSessionID] INT           IDENTITY (1, 1) NOT NULL,
    [DeviceID]        INT           NOT NULL,
    [BeginDateTime]   DATETIME2 (7) NOT NULL,
    [EndDateTime]     DATETIME2 (7) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_DeviceSession_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DeviceSessions_DeviceSessionID] PRIMARY KEY CLUSTERED ([DeviceSessionID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_DeviceSessions_Devices_DeviceID] FOREIGN KEY ([DeviceID]) REFERENCES [old].[Device] ([DeviceID])
);


GO
CREATE NONCLUSTERED INDEX [IX_DeviceSessions_EndTime]
    ON [old].[DeviceSession]([EndDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_DeviceSessions_DeviceId_BeginDateTimeID]
    ON [old].[DeviceSession]([DeviceID] ASC, [BeginDateTime] DESC, [DeviceSessionID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_DeviceSessions_DeviceId_BeginDateTime_EndTime]
    ON [old].[DeviceSession]([DeviceID] ASC, [BeginDateTime] ASC)
    INCLUDE([EndDateTime]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Device session', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'DeviceSession';

