CREATE TABLE [ICS].[Patient] (
    [PatientID]       INT           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Patient_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Patient_PatientID] PRIMARY KEY CLUSTERED ([PatientID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Patient';

