CREATE TABLE [Intesys].[Procedure] (
    [ProcedureID]               INT           IDENTITY (1, 1) NOT NULL,
    [EncounterID]               INT           NOT NULL,
    [ProcedureCodeID]           INT           NOT NULL,
    [SequenceNumber]            BIT           NOT NULL,
    [ProcedureDateTime]         DATETIME2 (7) NOT NULL,
    [ProcedureFunctionCodeID]   INT           NOT NULL,
    [ProcedureMinutes]          BIT           NOT NULL,
    [AnesthesiaCodeID]          INT           NULL,
    [AnesthesiaMinutes]         BIT           NULL,
    [ConsentCodeID]             INT           NOT NULL,
    [ProcedurePriority]         BIT           NULL,
    [AssociatedDiagnosisCodeID] INT           NOT NULL,
    [CreatedDateTime]           DATETIME2 (7) CONSTRAINT [DF_Procedure_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Procedure_ProcedureID] PRIMARY KEY CLUSTERED ([ProcedureID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Procedure_EncounterID_ProcedureCodeID_SequenceNumber]
    ON [Intesys].[Procedure]([EncounterID] ASC, [ProcedureCodeID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information relative to various types of procedures that can be performed on a patient.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Procedure';

