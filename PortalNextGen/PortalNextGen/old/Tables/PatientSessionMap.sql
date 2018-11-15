CREATE TABLE [old].[PatientSessionMap] (
    [PatientSessionMapID] INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]           INT           NOT NULL,
    [PatientSessionID]    INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_PatientSessionMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientSessionMap_PatientID_PatientSessionMapID] PRIMARY KEY CLUSTERED ([PatientID] ASC, [PatientSessionMapID] DESC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientSessionMap_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_PatientSessionMap_PatientSession_PatientSessionID] FOREIGN KEY ([PatientSessionID]) REFERENCES [old].[PatientSession] ([PatientSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PatientSessionMap_PatientID_PatientSessionID]
    ON [old].[PatientSessionMap]([PatientID] ASC, [PatientSessionID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PatientSessionMap_PatientSessionID_PatientSessionMapID]
    ON [old].[PatientSessionMap]([PatientSessionID] ASC, [PatientSessionMapID] DESC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PatientSessionMap';

