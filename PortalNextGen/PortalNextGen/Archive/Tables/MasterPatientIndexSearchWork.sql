CREATE TABLE [Archive].[MasterPatientIndexSearchWork] (
    [MasterPatientIndexSearchWorkID] INT           IDENTITY (1, 1) NOT NULL,
    [Spid]                           INT           NULL,
    [PersonID]                       INT           NULL,
    [CreatedDateTime]                DATETIME2 (7) CONSTRAINT [DF_MasterPatientIndexSearchWork_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexSearchWork_MasterPatientIndexSearchWorkID] PRIMARY KEY CLUSTERED ([MasterPatientIndexSearchWorkID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Work table that is used when searching the master patient index for a patient. The rows in this table are deleted after the search is finished.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexSearchWork';

