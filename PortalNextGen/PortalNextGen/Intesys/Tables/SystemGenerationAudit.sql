CREATE TABLE [Intesys].[SystemGenerationAudit] (
    [SystemGenerationAuditID] INT           IDENTITY (1, 1) NOT NULL,
    [AuditDateTime]           DATETIME2 (7) NOT NULL,
    [Audit]                   VARCHAR (255) NOT NULL,
    [CreatedDateTime]         DATETIME2 (7) CONSTRAINT [DF_SystemGenerationAudit_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SystemGenerationAudit_SystemGenerationAuditID] PRIMARY KEY CLUSTERED ([SystemGenerationAuditID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the system licensing information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SystemGenerationAudit';

