CREATE TABLE [old].[Enum] (
    [EnumID]          INT            IDENTITY (1, 1) NOT NULL,
    [GroupID]         INT            NOT NULL,
    [Name]            VARCHAR (50)   NOT NULL,
    [Value]           INT            NOT NULL,
    [Comment]         NVARCHAR (250) NOT NULL,
    [TopicTypeID]     INT            NULL,
    [GroupName]       VARCHAR (50)   NULL,
    [MetadataID]      INT            NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_Enum_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Enum_EnumID] PRIMARY KEY CLUSTERED ([EnumID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Enum_TopicType_TopicTypeID] FOREIGN KEY ([TopicTypeID]) REFERENCES [old].[TopicType] ([TopicTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Enum_GroupID_Name_Value]
    ON [old].[Enum]([GroupID] ASC, [Name] ASC, [Value] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Enum';

