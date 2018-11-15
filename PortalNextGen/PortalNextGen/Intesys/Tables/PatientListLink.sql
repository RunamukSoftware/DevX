CREATE TABLE [Intesys].[PatientListLink] (
    [PatientListLinkID] INT           IDENTITY (1, 1) NOT NULL,
    [MasterOwnerID]     INT           NOT NULL,
    [TransferOwnerID]   INT           NOT NULL,
    [PatientID]         INT           NULL,
    [StartDateTime]     DATETIME2 (7) NOT NULL,
    [EndDateTime]       DATETIME2 (7) NULL,
    [TypeCode]          CHAR (1)      NOT NULL,
    [Deleted]           TINYINT       NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_PatientListLink_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientListLink_PatientListLinkID] PRIMARY KEY CLUSTERED ([PatientListLinkID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientListLink_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientListLink_MasterOwnerID_TransferOwnerID_PatientID]
    ON [Intesys].[PatientListLink]([MasterOwnerID] ASC, [TransferOwnerID] ASC, [PatientID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table allows a user (usually a physician) to allow other users to view their patients. One typical usage is when a physician takes vacation and needs to "assign" patients to another physician for coverage. This table allows either complete assignment (all patients), or individual patients.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientListLink';

