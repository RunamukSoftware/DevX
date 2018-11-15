CREATE TABLE [Intesys].[EncounterMap] (
    [EncounterMapID]    INT           IDENTITY (1, 1) NOT NULL,
    [EncounterXID]      NVARCHAR (40) NOT NULL,
    [OrganizationID]    INT           NOT NULL,
    [EncounterID]       INT           NOT NULL,
    [PatientID]         INT           NOT NULL,
    [SequenceNumber]    INT           NOT NULL,
    [OriginalPatientID] INT           NULL,
    [StatusCode]        NVARCHAR (3)  NOT NULL,
    [EventCode]         NVARCHAR (4)  NOT NULL,
    [AccountID]         INT           NOT NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_EncounterMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_EncounterMap_EncounterMapID] PRIMARY KEY CLUSTERED ([EncounterMapID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_EncounterMap_Account_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Intesys].[Account] ([AccountID]),
    CONSTRAINT [FK_EncounterMap_Encounter_EncounterID] FOREIGN KEY ([EncounterID]) REFERENCES [Intesys].[Encounter] ([EncounterID]),
    CONSTRAINT [FK_EncounterMap_Organization] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID]),
    CONSTRAINT [FK_EncounterMap_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_EncounterMap_EncounterXID_OrganizationID_PatientID_StatusCode_AccountID_SequenceNumber]
    ON [Intesys].[EncounterMap]([EncounterXID] ASC, [OrganizationID] ASC, [PatientID] ASC, [StatusCode] ASC, [AccountID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_EncounterMap_EncounterID]
    ON [Intesys].[EncounterMap]([EncounterID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_EncounterMap_PatientID]
    ON [Intesys].[EncounterMap]([PatientID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A table that assigns an external visit number to an internal encounter record. This table allows an organization''s specific healthcare identifier (i.e. visit) to be mapped into a unique internal identifier (EncounterID). Within a specific organization, their identifiers for an encounter must be unique.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The external ID for the encounter (encounter number). These numbers must be unique for each organization.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'EncounterXID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization that this external ID is assigned by.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'OrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this result is associated with. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient this encounter is associated with. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequence number guarantees a unique record.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'SequenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the state in which the occurrence was created.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'StatusCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' A code that identifies the action that was processed  Probably not currently used', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'EventCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The account that is associated with this encounter link.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterMap', @level2type = N'COLUMN', @level2name = N'AccountID';

