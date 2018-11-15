CREATE TABLE [Configuration].[ValuePatient] (
    [ValuePatientID]        INT             IDENTITY (1, 1) NOT NULL,
    [PatientID]             INT             NOT NULL,
    [TypeCode]              VARCHAR (25)    NOT NULL,
    [ConfigurationName]     VARCHAR (40)    NOT NULL,
    [ConfigurationValue]    NVARCHAR (1800) NULL,
    [ConfigurationXmlValue] XML             NULL,
    [ValueType]             VARCHAR (20)    NOT NULL,
    [Timestamp]             DATETIME2 (7)   CONSTRAINT [DF_ValuePatient_Timestamp] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedDateTime]       DATETIME2 (7)   CONSTRAINT [DF_ValuePatient_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ValuePatient_ValuePatientID] PRIMARY KEY CLUSTERED ([ValuePatientID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ValuePatient_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ValuePatient_PatientID_TypeCode_ConfigurationName]
    ON [Configuration].[ValuePatient]([PatientID] ASC, [TypeCode] ASC, [ConfigurationName] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_ValuePatient_Timestamp_PatientID_TypeCode_ConfigurationName]
    ON [Configuration].[ValuePatient]([Timestamp] ASC)
    INCLUDE([PatientID], [TypeCode], [ConfigurationName]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains CH patient settings (gets populated if user goes into CH and modifies settings). TypeCode, ConfigurationName, and PatientID should be PKs.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'ValuePatient';

