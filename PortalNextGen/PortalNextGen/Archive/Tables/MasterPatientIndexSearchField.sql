CREATE TABLE [Archive].[MasterPatientIndexSearchField] (
    [MasterPatientIndexSearchFieldID] INT            IDENTITY (1, 1) NOT NULL,
    [FieldName]                       NVARCHAR (30)  NOT NULL,
    [ColumnName]                      NVARCHAR (30)  NULL,
    [Low]                             SMALLINT       NOT NULL,
    [High]                            SMALLINT       NOT NULL,
    [CompareType]                     NVARCHAR (30)  NULL,
    [CodeCategory]                    NVARCHAR (4)   NULL,
    [IsSecondary]                     INT            NULL,
    [IsPrimary]                       INT            NULL,
    [HL7Field]                        NVARCHAR (100) NULL,
    [CreatedDateTime]                 DATETIME2 (7)  CONSTRAINT [DF_MasterPatientIndexSearchField_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexSearchField_MasterPatientIndexSearchFieldID] PRIMARY KEY CLUSTERED ([MasterPatientIndexSearchFieldID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MasterPatientIndexSearchField_FieldName]
    ON [Archive].[MasterPatientIndexSearchField]([FieldName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains all fields you can do a MPI search on. You can change the weights that control how important each field is in the search. This table is used in the MPI search (either by the end user or during the background MPI lookup).', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexSearchField';

