CREATE TABLE [old].[Metadata] (
    [MetadataID]       INT           NOT NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [Value]            VARCHAR (MAX) NOT NULL,
    [IsLookUp]         BIT           NULL,
    [TopicTypeID]      INT           NULL,
    [EntityName]       VARCHAR (50)  NULL,
    [EntityMemberName] VARCHAR (50)  NULL,
    [DisplayOnly]      BIT           NOT NULL,
    [TypeID]           INT           NOT NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_Metadata_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Metadata_MetadataID] PRIMARY KEY CLUSTERED ([MetadataID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Metadata_TopicType_TopicTypeID] FOREIGN KEY ([TopicTypeID]) REFERENCES [old].[TopicType] ([TopicTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_MetadataID_Name_TypeID_TopicTypeID_DisplayOnly]
    ON [old].[Metadata]([MetadataID] ASC, [Name] ASC, [TypeID] ASC, [TopicTypeID] ASC, [DisplayOnly] ASC)
    INCLUDE([Value]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Name_MetadataID_TopicTypeID_EntityName_DisplayOnly_EntityMemberName_TypeID_Value]
    ON [old].[Metadata]([Name] ASC, [MetadataID] ASC, [TopicTypeID] ASC, [EntityName] ASC, [DisplayOnly] ASC, [EntityMemberName] ASC, [TypeID] ASC)
    INCLUDE([Value]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Name_MetadataID_TypeID_TopicTypeID_DisplayOnly_EntityName_Value]
    ON [old].[Metadata]([Name] ASC, [MetadataID] ASC, [TypeID] ASC, [TopicTypeID] ASC, [DisplayOnly] ASC)
    INCLUDE([EntityName], [Value]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_MetaData_DisplayOnly_MetadataID_TypeID_Name_EntityName_TopicTypeID_Value]
    ON [old].[Metadata]([DisplayOnly] ASC, [MetadataID] ASC, [TypeID] ASC, [Name] ASC)
    INCLUDE([EntityName], [TopicTypeID], [Value]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Metadata';

