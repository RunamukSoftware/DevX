CREATE TABLE [old].[LeadConfiguration] (
    [LeadConfigurationID] INT           IDENTITY (1, 1) NOT NULL,
    [LeadName]            NVARCHAR (50) NULL,
    [MonitorLoaderValue]  VARCHAR (20)  NULL,
    [DataLoaderValue]     VARCHAR (20)  NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_LeadConfiguration_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_LeadConfiguration_LeadConfigurationID] PRIMARY KEY CLUSTERED ([LeadConfigurationID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'LeadConfiguration';

