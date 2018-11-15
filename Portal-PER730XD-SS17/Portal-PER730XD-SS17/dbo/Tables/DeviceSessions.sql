CREATE TABLE [dbo].[DeviceSessions] (
    [Id]           UNIQUEIDENTIFIER NOT NULL,
    [DeviceId]     UNIQUEIDENTIFIER NULL,
    [BeginTimeUTC] DATETIME         NULL,
    [EndTimeUTC]   DATETIME         NULL,
    [Sequence]     BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL,
    [CreatedDateTime] DATETIME2(7) NOT NULL CONSTRAINT [DF_DeviceSessions_CreatedDateTime] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_DeviceSessions_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);
GO
CREATE NONCLUSTERED INDEX [IX_DeviceSessions_DeviceId]
ON [dbo].[DeviceSessions] ([DeviceId] ASC)
WITH (FILLFACTOR = 100);
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Device session',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'DeviceSessions';

GO
CREATE NONCLUSTERED INDEX [ix_DeviceSessions_Id]
    ON [dbo].[DeviceSessions]([Id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_DeviceSessions_EndTimeUTC]
    ON [dbo].[DeviceSessions]([EndTimeUTC] ASC) WITH (FILLFACTOR = 100);

