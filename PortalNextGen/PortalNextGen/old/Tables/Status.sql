CREATE TABLE [old].[Status] (
    [StatusID]        INT           IDENTITY (1, 1) NOT NULL,
    [SetID]           INT           NOT NULL,
    [Name]            VARCHAR (25)  NOT NULL,
    [Value]           VARCHAR (25)  NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Status_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Status_StatusID] PRIMARY KEY CLUSTERED ([StatusID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Status Data', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Status';

