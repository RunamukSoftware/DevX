CREATE TABLE [org].[Organization] (
    [OrganizationID]  INT           IDENTITY (1, 1) NOT NULL,
    [Name]            VARCHAR (50)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Organization_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Organization_OrganizationID] PRIMARY KEY CLUSTERED ([OrganizationID] ASC)
);

