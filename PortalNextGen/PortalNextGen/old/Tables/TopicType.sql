CREATE TABLE [old].[TopicType] (
    [TopicTypeID]     INT            NOT NULL,
    [Name]            VARCHAR (50)   NOT NULL,
    [BaseID]          INT            NULL,
    [Comment]         NVARCHAR (250) NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_TopicType_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TopicType_TopicTypeID] PRIMARY KEY CLUSTERED ([TopicTypeID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Topic Types', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'TopicType';

