CREATE TABLE [dbo].[PatientSessionsMap] (
    [PatientSessionId] UNIQUEIDENTIFIER NOT NULL,
    [PatientId]        UNIQUEIDENTIFIER NOT NULL,
    [Sequence]         BIGINT           IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    [CreatedDateTime] DATETIME2(7) NOT NULL CONSTRAINT [DF_PatientSessionsMap_CreatedDateTime] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_PatientSessionMap_PatientId_Sequence] PRIMARY KEY CLUSTERED ([PatientId] ASC, [Sequence] DESC) WITH (FILLFACTOR = 100)
);
GO
CREATE NONCLUSTERED INDEX [IX_PatientSessionsMap_PatientSessionId_Sequence]
    ON [dbo].[PatientSessionsMap]([PatientSessionId] ASC, [Sequence] DESC) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_PatientSessionsMap_PatientId_PatientSessionId]
    ON [dbo].[PatientSessionsMap]([PatientId] ASC, [PatientSessionId] ASC) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PatientSessionsMap';

