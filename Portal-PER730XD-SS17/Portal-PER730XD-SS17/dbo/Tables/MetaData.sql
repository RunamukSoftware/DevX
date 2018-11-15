CREATE TABLE [dbo].[MetaData] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [Name]             VARCHAR (50)     NOT NULL,
    [Value]            VARCHAR (MAX)    NOT NULL,
    [IsLookUp]         BIT              NULL,
    [MetaDataId]       UNIQUEIDENTIFIER NULL,
    [TopicTypeId]      UNIQUEIDENTIFIER NULL,
    [EntityName]       VARCHAR (50)     NULL,
    [EntityMemberName] VARCHAR (50)     NULL,
    [DisplayOnly]      BIT              NOT NULL,
    [TypeId]           UNIQUEIDENTIFIER NOT NULL
);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MetaData';
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_MetaData]
    ON [dbo].[MetaData];
