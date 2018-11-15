CREATE TABLE [Intesys].[HealthCareProviderSpecialty] (
    [HealthCareProviderSpecialtyID] INT           IDENTITY (1, 1) NOT NULL,
    [HealthCareProviderID]          INT           NOT NULL,
    [SpecialtyCodeID]               INT           NOT NULL,
    [GoverningBoard]                NVARCHAR (50) NULL,
    [CertificationCode]             NVARCHAR (20) NULL,
    [CertificationDateTime]         DATETIME2 (7) NULL,
    [CreatedDateTime]               DATETIME2 (7) CONSTRAINT [DF_HealthCareProviderSpecialty_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_HealthCareProviderSpecialty_HealthCareProviderSpecialtyID] PRIMARY KEY CLUSTERED ([HealthCareProviderSpecialtyID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HealthCareProviderSpecialty_HealthCareProviderid_SpecialtyCodeID]
    ON [Intesys].[HealthCareProviderSpecialty]([HealthCareProviderID] ASC, [SpecialtyCodeID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HealthCareProviderSpecialty_SpecialtyCodeID_HealthCareProviderID]
    ON [Intesys].[HealthCareProviderSpecialty]([SpecialtyCodeID] ASC, [HealthCareProviderID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the specialty(s) for each HCP. It includes information about what group/board certified the HCP.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'HealthCareProviderSpecialty';

