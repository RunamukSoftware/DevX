CREATE TABLE [Intesys].[TranslateList] (
    [TranslateListID] INT           IDENTITY (1, 1) NOT NULL,
    [ListID]          INT           NOT NULL,
    [TranslateCode]   VARCHAR (40)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_TranslateList_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TranslateList_TranslateListID] PRIMARY KEY CLUSTERED ([TranslateListID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TranslateList_ListID_TranslateCode]
    ON [Intesys].[TranslateList]([ListID] ASC, [TranslateCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is a temporary table used to pass data from a given web page to the editor used to edit tags. You can truncate this table at any time (that language tags are not being edited).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TranslateList';

