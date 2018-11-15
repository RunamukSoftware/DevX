CREATE TABLE [Intesys].[PatientListDetail] (
    [PatientListDetailID]   INT           IDENTITY (1, 1) NOT NULL,
    [PatientListID]         INT           NOT NULL,
    [PatientID]             INT           NOT NULL,
    [OriginalPatientID]     INT           NULL,
    [EncounterID]           INT           NOT NULL,
    [Deleted]               TINYINT       NOT NULL,
    [NewResults]            CHAR (1)      NULL,
    [ViewedResultsDateTime] DATETIME2 (7) NULL,
    [CreatedDateTime]       DATETIME2 (7) CONSTRAINT [DF_PatientListDetail_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientListDetail_PatientListDetailID] PRIMARY KEY CLUSTERED ([PatientListDetailID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientListDetail_Patient_PatientID] FOREIGN KEY ([OriginalPatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PatientListDetail_OriginalPatientID]
    ON [Intesys].[PatientListDetail]([OriginalPatientID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientListDetail_PatientListID_PatientID_EncounterID]
    ON [Intesys].[PatientListDetail]([PatientListID] ASC, [PatientID] ASC, [EncounterID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the patients that exist on a given patient list. It is the detail for a patient list. It therefore contains all patient entries for all patient lists (Unit, practicing, personal, etc.) It does not contain entries for the Search or Group lists (these are generated at run-time).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientListDetail';

