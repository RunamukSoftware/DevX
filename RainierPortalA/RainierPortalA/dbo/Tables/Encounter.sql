CREATE TABLE [dbo].[Encounter] (
    [EncounterID]     INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]       BIGINT        NOT NULL,
    [BedID]           INT           NOT NULL,
    [BeginDateTime]   DATETIME2 (7) NOT NULL,
    [EndDateTime]     DATETIME2 (7) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Encounter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Encounter_EncounterID] PRIMARY KEY CLUSTERED ([EncounterID] ASC),
    CONSTRAINT [FK_Encounter_Bed_BedID] FOREIGN KEY ([BedID]) REFERENCES [org].[Bed] ([BedID]),
    CONSTRAINT [FK_Encounter_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'From IHE: An interaction between a patient and care provider(s) for the purpose of providing healthcare-related service(s). Healthcare services include health assessment. For example, outpatient visit to multiple departments, home health support (including physical therapy), inpatient hospital stay, emergency room visit, field visit (e.g., traffic accident), office visit, occupational therapy, telephone call.


    An encounter is created on Admit and remains until Discharge.

    A patient is always in a bed.   Not such thing as patient without a bed.

    A Transfer is just changing beds.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Encounter';

