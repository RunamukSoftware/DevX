CREATE TABLE [Intesys].[ProcedureHealthCareProvider] (
    [ProcedureHealthCareProviderID]    INT           IDENTITY (1, 1) NOT NULL,
    [EncounterID]                      INT           NOT NULL,
    [procedureCodeID]                  INT           NOT NULL,
    [SequenceNumber]                   INT           NOT NULL,
    [DescriptionKey]                   INT           NOT NULL,
    [HealthCareProviderID]             INT           NOT NULL,
    [procHealthCareProvidertypeCodeID] INT           NOT NULL,
    [CreatedDateTime]                  DATETIME2 (7) CONSTRAINT [DF_ProcedureHealthCareProvider_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ProcedureHealthCareProvider_ProcedureHealthCareProviderID] PRIMARY KEY CLUSTERED ([ProcedureHealthCareProviderID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProcedureHealthCareProvider_EncounterID_ProcedureCodeID_SequenceNumber_DescriptionKey]
    ON [Intesys].[ProcedureHealthCareProvider]([EncounterID] ASC, [procedureCodeID] ASC, [SequenceNumber] ASC, [DescriptionKey] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the HCP(s) that were involved in a procedure. There can multiple HCP(s) for each procedure and multiple types of HCP(s).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ProcedureHealthCareProvider';

