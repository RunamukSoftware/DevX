CREATE TABLE [old].[PatientSession] (
    [PatientSessionID] INT           IDENTITY (1, 1) NOT NULL,
    [BeginDateTime]    DATETIME2 (7) NOT NULL,
    [EndDateTime]      DATETIME2 (7) NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_PatientSession_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientSession_PatientSessionID] PRIMARY KEY CLUSTERED ([PatientSessionID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_PatientSessions_PatientSessionID_BeginDateTime_EndTime]
    ON [old].[PatientSession]([PatientSessionID] ASC)
    INCLUDE([BeginDateTime], [EndDateTime]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PatientSession';

