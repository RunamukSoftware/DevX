CREATE TABLE [Intesys].[PatientProcedure] (
    [PatientProcedureID]  INT           IDENTITY (1, 1) NOT NULL,
    [EncounterID]         INT           NOT NULL,
    [ProcedureCodeID]     INT           NOT NULL,
    [SequenceNumber]      SMALLINT      NOT NULL,
    [procDateTime]        DATETIME2 (7) NOT NULL,
    [proc_functionCodeID] INT           NOT NULL,
    [proc_minutes]        SMALLINT      NOT NULL,
    [anesthesiaCodeID]    INT           NULL,
    [anesthesia_minutes]  SMALLINT      NULL,
    [consentCodeID]       INT           NOT NULL,
    [proc_priority]       TINYINT       NULL,
    [assoc_diagCodeID]    INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_PatientProcedure_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientProcedure_PatientProcedureID] PRIMARY KEY CLUSTERED ([PatientProcedureID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientProcedure_EncounterID_ProcedureCodeID]
    ON [Intesys].[PatientProcedure]([EncounterID] ASC, [ProcedureCodeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information relative to various types of procedures that can be performed on a patient.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientProcedure';

