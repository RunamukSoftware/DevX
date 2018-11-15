CREATE TABLE [Intesys].[ExternalOrganization] (
    [ExternalOrganizationID]       INT           IDENTITY (1, 1) NOT NULL,
    [CategoryCode]                 NCHAR (1)     NULL,
    [OrganizationName]             NVARCHAR (50) NULL,
    [ParentExternalOrganizationID] INT           NULL,
    [OrganizationCode]             NVARCHAR (30) NULL,
    [CompanyCons]                  NVARCHAR (50) NULL,
    [CreatedDateTime]              DATETIME2 (7) CONSTRAINT [DF_ExternalOrganization_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ExternalOrganization_ExternalOrganizationID] PRIMARY KEY CLUSTERED ([ExternalOrganizationID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all "external" organizations. External organizations have been separated from internal organizations. External organizations are organizations that are not located within the hospital or facility such as insurance companies and employers. Internal organizations are those that are part of the hospital or facility such as  units.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ExternalOrganization';

