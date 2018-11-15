CREATE TABLE [dbo].[TopicSessions] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [TopicTypeId]      UNIQUEIDENTIFIER NULL,
    [TopicInstanceId]  UNIQUEIDENTIFIER NULL,
    [DeviceSessionId]  UNIQUEIDENTIFIER NULL,
    [PatientSessionId] UNIQUEIDENTIFIER NULL,
    [BeginTimeUTC]     DATETIME         NOT NULL,
    [EndTimeUTC]       DATETIME         NULL,
    [Sequence]         BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL,
    [CreatedDateTime] DATETIME2(7) NOT NULL CONSTRAINT [DF_TopicSessions_CreatedDateTime] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_TopicSessions_BeginTimeUTC_Sequence] PRIMARY KEY CLUSTERED ([BeginTimeUTC] ASC, [Sequence] ASC) WITH (FILLFACTOR = 100)
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TopicSessions_Id]
    ON [dbo].[TopicSessions]([Id] ASC) WITH (FILLFACTOR = 100);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TopicSessions_PatientSessionId_TopicInstanceId_BeginTimeUTC]
    ON [dbo].[TopicSessions]([PatientSessionId] ASC, [TopicInstanceId] ASC, [BeginTimeUTC] ASC) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_TopicSessions_PatientSessionId_Id_DeviceSessionId]
    ON [dbo].[TopicSessions]([PatientSessionId] ASC, [Id] ASC, [DeviceSessionId] ASC) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_TopicSessions_TopicInstanceId_EndTimeUTC_Id_PatientSessionId]
    ON [dbo].[TopicSessions]([TopicInstanceId] ASC, [EndTimeUTC] ASC)
    INCLUDE([Id], [PatientSessionId]) WITH (FILLFACTOR = 100);
GO
CREATE TRIGGER [dbo].[trg_TopicSessions_CloseAlarms] ON [dbo].[TopicSessions]
    FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [TopicSessionUpdatesWithEndTime].[TopicSessionId],
        MAX([TopicSessionUpdatesWithEndTime].[EndTimeUTC]) AS [EndTimeUTC]
    INTO
        [#ClosingTimes]
    FROM
        (SELECT
            [Inserted].[Id] AS [TopicSessionId],
            [Inserted].[EndTimeUTC]
         FROM
            [Inserted]
         WHERE
            [Inserted].[EndTimeUTC] IS NOT NULL
        ) AS [TopicSessionUpdatesWithEndTime]
    GROUP BY
        [TopicSessionUpdatesWithEndTime].[TopicSessionId];

    UPDATE
        [dbo].[GeneralAlarmsData]
    SET
        [EndDateTime] = [Src].[EndTimeUTC]
    FROM
        [#ClosingTimes] AS [Src]
    WHERE
        [GeneralAlarmsData].[TopicSessionId] = [Src].[TopicSessionId]
        AND [GeneralAlarmsData].[EndDateTime] IS NULL;

    UPDATE
        [dbo].[LimitAlarmsData]
    SET
        [EndDateTime] = [Src].[EndTimeUTC]
    FROM
        [#ClosingTimes] AS [Src]
    WHERE
        [LimitAlarmsData].[TopicSessionId] = [Src].[TopicSessionId]
        AND [LimitAlarmsData].[EndDateTime] IS NULL;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TopicSessions';
GO
CREATE NONCLUSTERED INDEX [IX_TopicSessions_EndTimeUTC]
    ON [dbo].[TopicSessions]([EndTimeUTC] ASC) WITH (FILLFACTOR = 100);

