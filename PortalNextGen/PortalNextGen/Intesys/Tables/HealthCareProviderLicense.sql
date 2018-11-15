CREATE TABLE [Intesys].[HealthCareProviderLicense] (
    [HealthCareProviderLicenseID] INT           IDENTITY (1, 1) NOT NULL,
    [HealthCareProviderID]        INT           NOT NULL,
    [LicenseTypeCodeID]           INT           NOT NULL,
    [LicenseStateCode]            NVARCHAR (3)  NOT NULL,
    [LicenseXID]                  NVARCHAR (10) NULL,
    [EffectiveDateTime]           DATETIME2 (7) NULL,
    [ExpirationDateTime]          DATETIME2 (7) NULL,
    [CreatedDateTime]             DATETIME2 (7) CONSTRAINT [DF_HealthCareProviderLicense_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_HealthCareProviderLicense_HealthCareProviderLicenseID] PRIMARY KEY CLUSTERED ([HealthCareProviderLicenseID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HealthCareProviderLicense_HealthCareProviderID_license_type_cid_license_xid_license_state_code]
    ON [Intesys].[HealthCareProviderLicense]([HealthCareProviderID] ASC, [LicenseTypeCodeID] ASC, [LicenseXID] ASC, [LicenseStateCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all certification(s) associated with each HCP. A certification that is acquired by a healthcare professional to provide a service in a Healthcare FACILITY/ORGANIZATION.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'HealthCareProviderLicense';

