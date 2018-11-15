CREATE TABLE [dbo].[Enums] (
    [GroupId]     UNIQUEIDENTIFIER NOT NULL,
    [Name]        VARCHAR (50)     NOT NULL,
    [Value]       INT              NOT NULL,
    [Comment]     NVARCHAR (250)   NOT NULL,
    [TopicTypeId] UNIQUEIDENTIFIER NULL,
    [GroupName]   VARCHAR (50)     NULL,
    [MetadataId]  UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_Enums_GroupId_Name_Value] PRIMARY KEY CLUSTERED ([GroupId] ASC, [Name] ASC, [Value] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Enums';

