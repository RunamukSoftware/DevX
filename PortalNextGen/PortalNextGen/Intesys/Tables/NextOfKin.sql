CREATE TABLE [Intesys].[NextOfKin] (
    [NextOfKinID]          INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]            INT           NOT NULL,
    [SequenceNumber]       INT           NOT NULL,
    [NotifySequenceNumber] INT           NOT NULL,
    [ActiveFlag]           TINYINT       NOT NULL,
    [OriginalPatientID]    INT           NULL,
    [NextOfKinPersonID]    INT           NOT NULL,
    [ContactPersonID]      INT           NULL,
    [RelationshipCodeID]   INT           NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_NextOfKin_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_NextOfKin_NextOfKinID] PRIMARY KEY CLUSTERED ([NextOfKinID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_NextOfKin_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NextOfKin_PatientID_SequenceNumber_NotifySequenceNumber_ActiveFlag]
    ON [Intesys].[NextOfKin]([PatientID] ASC, [SequenceNumber] ASC, [NotifySequenceNumber] ASC, [ActiveFlag] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the Next of Kin for patients. Every patient can have Next of Kin (as defined in the NK1 segment in HL/7). Next Of Kin''s are not encounter based, they are patient based. However there can be multiple Next Of Kin''s for each patient.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'NextOfKin';

