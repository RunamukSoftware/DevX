CREATE TABLE [old].[GlobalDataSystemCodeMap] (
    [GlobalDataSystemCodeMapID] INT           IDENTITY (1, 1) NOT NULL,
    [FeedTypeID]                INT           NOT NULL,
    [Name]                      VARCHAR (25)  NOT NULL,
    [GlobalDataSystemCode]      VARCHAR (25)  NOT NULL,
    [CodeID]                    INT           NOT NULL,
    [Units]                     VARCHAR (25)  NULL,
    [Description]               NVARCHAR (50) NULL,
    [CreatedDateTime]           DATETIME2 (7) CONSTRAINT [DF_GlobalDataSystemCodeMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_GlobalDataSystemCodeMap_GlobalDataSystemCodeMapID] PRIMARY KEY CLUSTERED ([GlobalDataSystemCodeMapID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_GlobalDataSystemCodeMap_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_GlobalDataSystemCodeMap_GlobalDataSystemCode_CodeID_Description_Units_FeedTypeID_Name]
    ON [old].[GlobalDataSystemCodeMap]([GlobalDataSystemCode] ASC)
    INCLUDE([CodeID], [Description], [Units], [FeedTypeID], [Name]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_GlobalDataSystemCodeMap_FeedTypeID_Name]
    ON [old].[GlobalDataSystemCodeMap]([FeedTypeID] ASC, [Name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'GlobalDataSystemCodeMap';

