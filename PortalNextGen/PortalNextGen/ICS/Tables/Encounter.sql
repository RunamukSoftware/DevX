CREATE TABLE [ICS].[Encounter] (
    [EncounterID]     INT           NOT NULL,
    [PatientID]       INT           NOT NULL,
    [BeginDateTime]   DATETIME2 (7) NOT NULL,
    [EndDateTime]     DATETIME2 (7) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Encounter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Encounter_EncounterID] PRIMARY KEY CLUSTERED ([EncounterID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Encounter_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [ICS].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Encounter';

