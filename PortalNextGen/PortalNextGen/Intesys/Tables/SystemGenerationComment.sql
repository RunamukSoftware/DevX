CREATE TABLE [Intesys].[SystemGenerationComment] (
    [SystemGenerationCommentID] INT           IDENTITY (1, 1) NOT NULL,
    [CommentDateTime]           DATETIME2 (7) NOT NULL,
    [Comment]                   VARCHAR (255) NOT NULL,
    [CreatedDateTime]           DATETIME2 (7) CONSTRAINT [DF_SystemGenerationComment_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SystemGenerationComment_SystemGenerationCommentID] PRIMARY KEY CLUSTERED ([SystemGenerationCommentID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores comments about system generation.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SystemGenerationComment';

