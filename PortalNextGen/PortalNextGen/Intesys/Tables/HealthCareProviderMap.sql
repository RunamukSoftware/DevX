CREATE TABLE [Intesys].[HealthCareProviderMap] (
    [HealthCareProviderMapID] INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]          INT           NOT NULL,
    [HealthCareProviderXID]   NVARCHAR (20) NOT NULL,
    [HealthCareProviderID]    INT           NOT NULL,
    [CreatedDateTime]         DATETIME2 (7) CONSTRAINT [DF_HealthCareProviderMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_HealthCareProviderMap_HealthCareProviderMapID] PRIMARY KEY CLUSTERED ([HealthCareProviderMapID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_HealthCareProviderMap_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_intHealthCareProvidermap_OrganizationID_HealthCareProviderXID]
    ON [Intesys].[HealthCareProviderMap]([OrganizationID] ASC, [HealthCareProviderXID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table maps the external id for an HCP to the internal id (HealthCareProviderID). An HCP may have multiple external id''s so this table is required. However, within an organization, ID''s must be unique.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'HealthCareProviderMap';

