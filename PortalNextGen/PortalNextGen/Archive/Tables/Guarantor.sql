CREATE TABLE [Archive].[Guarantor] (
    [GuarantorID]            INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]              INT           NOT NULL,
    [SequenceNumber]         INT           NOT NULL,
    [TypeCode]               NCHAR (2)     NOT NULL,
    [ActiveSwitch]           BIT           NOT NULL,
    [OriginalPatientID]      INT           NULL,
    [RelationshipCodeID]     INT           NOT NULL,
    [EncounterID]            INT           NOT NULL,
    [ExternalOrganizationID] INT           NOT NULL,
    [GuarantorPersonID]      INT           NOT NULL,
    [EmployerID]             INT           NOT NULL,
    [SpouseID]               INT           NOT NULL,
    [ContactID]              INT           NOT NULL,
    [CreatedDateTime]        DATETIME2 (7) CONSTRAINT [DF_Guarantor_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Guarantor_GuarantorID] PRIMARY KEY CLUSTERED ([GuarantorID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Guarantor_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Guarantor_PatientID_GuarantorID_SequenceNumber]
    ON [Archive].[Guarantor]([PatientID] ASC, [GuarantorID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores guarantor information supplied in the GT1 segment of HL/7.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'Guarantor';

