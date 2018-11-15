CREATE TABLE [Intesys].[EncounterTransferHistory] (
    [EncounterTransferHistoryID]  INT           IDENTITY (1, 1) NOT NULL,
    [EncounterXID]                NVARCHAR (30) NOT NULL,
    [OrganizationID]              INT           NOT NULL,
    [EncounterID]                 INT           NOT NULL,
    [PatientID]                   INT           NOT NULL,
    [OriginalPatientID]           INT           NULL,
    [TransferTransactionDateTime] DATETIME2 (7) NULL,
    [TransferredFromEncounterID]  INT           NULL,
    [TransferredToEncounterID]    INT           NULL,
    [TransferredFromPatientID]    INT           NULL,
    [TransferredToPatientID]      INT           NULL,
    [StatusCode]                  NCHAR (1)     NULL,
    [EventCode]                   NVARCHAR (4)  NULL,
    [CreatedDateTime]             DATETIME2 (7) CONSTRAINT [DF_EncounterTransferHistory_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_EncounterTransferHistory_EncounterTransferHistoryID] PRIMARY KEY CLUSTERED ([EncounterTransferHistoryID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_EncounterTransferHistory_Encounter_EncounterID] FOREIGN KEY ([EncounterID]) REFERENCES [Intesys].[Encounter] ([EncounterID]),
    CONSTRAINT [FK_EncounterTransferHistory_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID]),
    CONSTRAINT [FK_EncounterTransferHistory_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_EncounterTransferHistory_EncounterXID_OrganizationID]
    ON [Intesys].[EncounterTransferHistory]([EncounterXID] ASC, [OrganizationID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A table that tracks the moving and merging of encounters within the Database. When an encounter move or merge takes place, this table will capture the surviving and non-surviving patient and encounter ID''s.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An attribute that uniquely identifies the External Visit Number assigned by the ENCOUNTER assigning ORGANIZATION. This is usually the patient number or billing number for simple  encounter/account relationships. Whenever an external system provides an identifier to  the system, that eXternal IDentifier is referred to as an XID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'EncounterXID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization that the encounter that was moved/merged is associated with.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'OrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization that the encounter that was moved/merged is associated with.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient associated with the transfer (not necessarily the source or destination).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time in which the transfer has taken place.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'TransferTransactionDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time in which the transfer has taken place.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'TransferredFromEncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This attribute identifies the ENCOUNTER ENTITY IDENTIFICATION for the surviving ENCOUNTER.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'TransferredToEncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This attribute identifies the ENCOUNTER ENTITY IDENTIFICATION for the non-surviving PATIENT.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'TransferredFromPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This attribute identifies the Patient (PatientID) for the surviving PATIENT.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'TransferredToPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the state in which the occurrence was created.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'StatusCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the action that was processed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterTransferHistory', @level2type = N'COLUMN', @level2name = N'EventCode';

