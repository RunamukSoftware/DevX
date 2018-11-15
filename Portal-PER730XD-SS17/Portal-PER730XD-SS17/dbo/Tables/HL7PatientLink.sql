CREATE TABLE [dbo].[HL7PatientLink] (
    [MessageNo]          INT              NOT NULL,
    [PatientMrn]         NVARCHAR (20)    NOT NULL,
    [PatientVisitNumber] NVARCHAR (20)    NOT NULL,
    [PatientId]          UNIQUEIDENTIFIER NULL,
    CONSTRAINT [FK_HL7PatientLink_HL7InboundMessage_MessageNo] FOREIGN KEY ([MessageNo]) REFERENCES [dbo].[HL7InboundMessage] ([MessageNo])
);


GO
CREATE NONCLUSTERED INDEX [IX_HL7PatientLink_MessageNo]
    ON [dbo].[HL7PatientLink]([MessageNo] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HL7PatientLink';

