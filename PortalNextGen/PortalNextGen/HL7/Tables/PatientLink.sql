CREATE TABLE [HL7].[PatientLink] (
    [PatientLinkID]              INT           IDENTITY (1, 1) NOT NULL,
    [MessageNumber]              INT           NOT NULL,
    [PatientMedicalRecordNumber] NVARCHAR (20) NOT NULL,
    [PatientVisitNumber]         NVARCHAR (20) NOT NULL,
    [PatientID]                  INT           NULL,
    [CreatedDateTime]            DATETIME2 (7) CONSTRAINT [DF_PatientLink_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientLink_PatientLinkID] PRIMARY KEY CLUSTERED ([PatientLinkID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientLink_InboundMessage_MessageNumber] FOREIGN KEY ([MessageNumber]) REFERENCES [HL7].[InboundMessage] ([MessageNumber]),
    CONSTRAINT [FK_PatientLink_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [Intesys].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PatientLink_MessageNumber]
    ON [HL7].[PatientLink]([MessageNumber] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_HL7PatientLink_MessageNumber]
    ON [HL7].[PatientLink]([MessageNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'TABLE', @level1name = N'PatientLink';

