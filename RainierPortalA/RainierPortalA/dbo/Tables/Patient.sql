CREATE TABLE [dbo].[Patient] (
    [PatientID]       BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Patient_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Patient_PatientID] PRIMARY KEY CLUSTERED ([PatientID] ASC) WITH (FILLFACTOR = 100)
);

