CREATE TABLE [old].[Encounter] (
    [EncounterID]     INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]       INT           NOT NULL,
    [BeginDateTime]   DATETIME2 (7) NOT NULL,
    [EndDateTime]     DATETIME2 (7) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Encounter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Encounter_EncounterID] PRIMARY KEY CLUSTERED ([EncounterID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Encounter_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [Intesys].[Patient] ([PatientID])
);

