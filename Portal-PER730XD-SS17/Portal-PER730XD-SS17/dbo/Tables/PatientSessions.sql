CREATE TABLE [dbo].[PatientSessions] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [BeginTimeUTC]    DATETIME         NOT NULL,
    [EndTimeUTC]      DATETIME         NULL,
    [Sequence]        BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL,
    [CreatedDateTime] DATETIME2 (7)    CONSTRAINT [DF_PatientSessions_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientSessions_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PatientSessions';


GO
CREATE NONCLUSTERED INDEX [IX_PatientSessions_EndTimeUTC_Id]
    ON [dbo].[PatientSessions]([EndTimeUTC] ASC, [Id] ASC);

