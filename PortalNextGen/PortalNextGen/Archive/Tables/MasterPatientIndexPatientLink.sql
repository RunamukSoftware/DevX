CREATE TABLE [Archive].[MasterPatientIndexPatientLink] (
    [MasterPatientIndexPatientLinkID] INT           IDENTITY (1, 1) NOT NULL,
    [OriginalPatientID]               INT           NOT NULL,
    [NewPatientID]                    INT           NOT NULL,
    [UserID]                          INT           NULL,
    [ModifiedDateTime]                DATETIME2 (7) NOT NULL,
    [CreatedDateTime]                 DATETIME2 (7) CONSTRAINT [DF_MasterPatientIndexPatientLink_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexPatientLink_MasterPatientIndexPatientLinkID] PRIMARY KEY CLUSTERED ([MasterPatientIndexPatientLinkID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MasterPatientIndexPatientLink_OriginalPatientID_NewPatientID]
    ON [Archive].[MasterPatientIndexPatientLink]([OriginalPatientID] ASC, [NewPatientID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to track patients that have been linked (i.e. are really the same patient). For a lot of reasons, a patient may have multiple patient records. Linking allows these duplicate records to be merged in such a way that allows them to later be "unlinked".', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexPatientLink';

