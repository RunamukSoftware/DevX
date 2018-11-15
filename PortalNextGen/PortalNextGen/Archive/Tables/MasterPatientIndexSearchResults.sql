CREATE TABLE [Archive].[MasterPatientIndexSearchResults] (
    [MasterPatientIndexSearchResultsID] INT           IDENTITY (1, 1) NOT NULL,
    [Spid]                              INT           NULL,
    [PersonID]                          INT           NULL,
    [CreatedDateTime]                   DATETIME2 (7) CONSTRAINT [DF_MasterPatientIndexSearchResults_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexSearchResults_MasterPatientIndexSearchResultsID] PRIMARY KEY CLUSTERED ([MasterPatientIndexSearchResultsID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexSearchResults';

