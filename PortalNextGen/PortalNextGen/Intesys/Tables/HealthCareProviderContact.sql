CREATE TABLE [Intesys].[HealthCareProviderContact] (
    [HealthCareProviderContactID] INT           IDENTITY (1, 1) NOT NULL,
    [HealthCareProviderID]        INT           NOT NULL,
    [ContactTypeCodeID]           INT           NOT NULL,
    [SequenceNumber]              SMALLINT      NOT NULL,
    [ContactNumber]               NVARCHAR (40) NOT NULL,
    [ContactExtension]            NVARCHAR (12) NOT NULL,
    [CreatedDateTime]             DATETIME2 (7) CONSTRAINT [DF_HealthCareProviderContact_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_HealthCareProviderContact_HealthCareProviderContactID] PRIMARY KEY CLUSTERED ([HealthCareProviderContactID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HealthCareProviderContact_HealthCareProviderID_ContactTypeCodeID_SequenceNumber]
    ON [Intesys].[HealthCareProviderContact]([HealthCareProviderID] ASC, [ContactTypeCodeID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the contact information for HCP''s. This includes phone number''s, pagers, e-mail addresses, etc.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'HealthCareProviderContact';

