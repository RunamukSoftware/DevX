CREATE TABLE [ICS].[Organization] (
    [OrganizationID]  INT           IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Organization_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Organization_OrganizationID] PRIMARY KEY CLUSTERED ([OrganizationID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Organization';

