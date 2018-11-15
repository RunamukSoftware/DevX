CREATE TABLE [Intesys].[PatientLink] (
    [OriginalPatientID] INT           NOT NULL,
    [NewPatientID]      INT           NOT NULL,
    [UserID]            INT           NULL,
    [MonitorID]         INT           NULL,
    [ModifiedDateTime]  DATETIME2 (7) NOT NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_PatientLink_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientLink_OriginalPatientID_NewPatientID] PRIMARY KEY CLUSTERED ([OriginalPatientID] ASC, [NewPatientID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientLink_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table tracks all patients that have been linked or merged. It allows patients to be linked (i.e. they are identified to be the same patient). It also allows patients to later be unlinked if they were mistakenly linked.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientLink';

