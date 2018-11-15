CREATE TABLE [Intesys].[HealthCareProvider] (
    [HealthCareProviderID] INT           IDENTITY (1, 1) NOT NULL,
    [hcp_typeCodeID]       INT           NULL,
    [LastName]             NVARCHAR (50) NULL,
    [FirstName]            NVARCHAR (50) NULL,
    [MiddleName]           NVARCHAR (50) NULL,
    [degree]               NVARCHAR (20) NULL,
    [VerificationSwitch]   BIT           NOT NULL,
    [doctor_insNumberID]   NVARCHAR (10) NULL,
    [doctor_deaNumber]     NVARCHAR (10) NULL,
    [medicareID]           NVARCHAR (12) NULL,
    [medicaidID]           NVARCHAR (20) NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_HealthCareProvider_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_HealthCareProvider_HealthCareProviderID] PRIMARY KEY CLUSTERED ([HealthCareProviderID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HCP table stores all HCP''s referenced in HL/7 messages. HCP''s are any individuals who perform a role as a clinical employee, provider or authorized affiliates of a Healthcare ORGANIZATION. The HCP''s name (first name, last name, middle initial, and degree) are carried as redundant data within the HCP table in order to eliminate a join back to the PERSON_NAME table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'HealthCareProvider';

