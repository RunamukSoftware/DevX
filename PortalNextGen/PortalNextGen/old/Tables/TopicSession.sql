CREATE TABLE [old].[TopicSession] (
    [TopicSessionID]   INT           IDENTITY (1, 1) NOT NULL,
    [TopicTypeID]      INT           NOT NULL,
    [TopicInstanceID]  INT           NOT NULL,
    [DeviceSessionID]  INT           NOT NULL,
    [PatientSessionID] INT           NOT NULL,
    [BeginDateTime]    DATETIME2 (7) NOT NULL,
    [EndDateTime]      DATETIME2 (7) NOT NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_TopicSession_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TopicSessions_TopicSessionID] PRIMARY KEY CLUSTERED ([TopicSessionID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_TopicSession_DeviceSession_DeviceSessionID] FOREIGN KEY ([DeviceSessionID]) REFERENCES [old].[DeviceSession] ([DeviceSessionID]),
    CONSTRAINT [FK_TopicSession_TopicType_TopicTypeID] FOREIGN KEY ([TopicTypeID]) REFERENCES [old].[TopicType] ([TopicTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSessionID_TopicInstanceID]
    ON [old].[TopicSession]([TopicSessionID] ASC)
    INCLUDE([TopicInstanceID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_TopicInstanceID_EndTimeUTCID_PatientSessionID]
    ON [old].[TopicSession]([TopicInstanceID] ASC, [EndDateTime] ASC)
    INCLUDE([TopicSessionID], [PatientSessionID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_PatientSessionIDID_DeviceSessionID]
    ON [old].[TopicSession]([PatientSessionID] ASC, [TopicSessionID] ASC, [DeviceSessionID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_DeviceSessionIDID_PatientSessionID]
    ON [old].[TopicSession]([DeviceSessionID] ASC)
    INCLUDE([TopicSessionID], [PatientSessionID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicsSession_DeviceSessionID_EndTimeUTC_TopicInstanceID_PatientSessionID_BeginDateTime]
    ON [old].[TopicSession]([DeviceSessionID] ASC, [EndDateTime] ASC)
    INCLUDE([BeginDateTime], [PatientSessionID], [TopicInstanceID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_DeviceSessionIDID_BeginDateTime]
    ON [old].[TopicSession]([DeviceSessionID] ASC, [TopicSessionID] ASC)
    INCLUDE([BeginDateTime]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_DeviceSessionID_BeginDateTimeID_PatientSessionID]
    ON [old].[TopicSession]([DeviceSessionID] ASC, [BeginDateTime] ASC)
    INCLUDE([TopicSessionID], [PatientSessionID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_DeviceSessionID_BeginDateTimeID]
    ON [old].[TopicSession]([DeviceSessionID] ASC, [BeginDateTime] ASC)
    INCLUDE([TopicSessionID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_TopicSession_BeginDateTime_EndDateTime]
    ON [old].[TopicSession]([BeginDateTime] ASC, [EndDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE TRIGGER [old].[trg_TopicSession_CloseAlarms]
ON [old].[TopicSession]
FOR INSERT, UPDATE
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [TopicSessionUpdatesWithEndTime].[TopicSessionID],
            MAX([TopicSessionUpdatesWithEndTime].[EndDateTime]) AS [EndDateTime]
        INTO
            [#ClosingTimes]
        FROM
            (
                SELECT
                    [Inserted].[TopicSessionID],
                    [Inserted].[EndDateTime]
                FROM
                    [Inserted]
                WHERE
                    [Inserted].[EndDateTime] IS NOT NULL
            ) AS [TopicSessionUpdatesWithEndTime]
        GROUP BY
            [TopicSessionUpdatesWithEndTime].[TopicSessionID];

        UPDATE
            [old].[GeneralAlarm]
        SET
            [EndDateTime] = [src].[EndDateTime]
        FROM
            [#ClosingTimes] AS [src]
        WHERE
            [GeneralAlarm].[TopicSessionID] = [src].[TopicSessionID]
            AND [GeneralAlarm].[EndDateTime] IS NULL;

        UPDATE
            [old].[LimitAlarm]
        SET
            [EndDateTime] = [src].[EndDateTime]
        FROM
            [#ClosingTimes] AS [src]
        WHERE
            [LimitAlarm].[TopicSessionID] = [src].[TopicSessionID]
            AND [LimitAlarm].[EndDateTime] IS NULL;

        DROP TABLE [#ClosingTimes];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'TopicSession';

