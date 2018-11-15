CREATE TABLE [old].[PrintRequestDescription] (
    [PrintRequestDescriptionID] INT           IDENTITY (1, 1) NOT NULL,
    [RequestTypeEnumID]         INT           NOT NULL,
    [RequestTypeEnumValue]      INT           NOT NULL,
    [Value]                     VARCHAR (25)  NOT NULL,
    [CreatedDateTime]           DATETIME2 (7) CONSTRAINT [DF_PrintRequestDescription_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintRequestDescription_PrintRequestDescriptionID] PRIMARY KEY CLUSTERED ([PrintRequestDescriptionID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PrintRequestDescription';

