CREATE TABLE [dbo].[GdsCodeMap]
    ([FeedTypeId] UNIQUEIDENTIFIER NOT NULL,
     [Name] VARCHAR(25) NOT NULL,
     [GdsCode] VARCHAR(25) NOT NULL,
     [CodeId] INT NOT NULL,
     [Units] VARCHAR(25) NULL,
     [Description] NVARCHAR(50) NULL,
     CONSTRAINT [PK_GdsCodeMap_FeedTypeId_Name]
         PRIMARY KEY CLUSTERED
         (
         [FeedTypeId] ASC,
         [Name] ASC)
         WITH (FILLFACTOR = 100));
GO
CREATE NONCLUSTERED INDEX [IX_GdsCodeMap_GdsCode_CodeId_Description_Units_FeedTypeId_Name]
ON [dbo].[GdsCodeMap] ([GdsCode] ASC)
INCLUDE
(
[CodeId],
[Description],
[Units],
[FeedTypeId],
[Name])
WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_GdsCodeMap_CodeId]
ON [dbo].[GdsCodeMap] ([CodeId] ASC)
WITH (FILLFACTOR = 100);
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'<Table description here>',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'GdsCodeMap';
