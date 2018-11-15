CREATE TABLE [Intesys].[SystemParameter] (
    [SystemParameterID]    INT            IDENTITY (1, 1) NOT NULL,
    [Name]                 NVARCHAR (30)  NOT NULL,
    [ParameterValue]       NVARCHAR (80)  NOT NULL,
    [ActiveFlag]           BIT            NOT NULL,
    [AfterDischargeSwitch] BIT            NOT NULL,
    [DebugSwitch]          BIT            NOT NULL,
    [Description]          NVARCHAR (255) NOT NULL,
    [CreatedDateTime]      DATETIME2 (7)  CONSTRAINT [DF_SystemParameter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SystemParameter_SystemParameterID] PRIMARY KEY CLUSTERED ([SystemParameterID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SystemParameter_SystemParameterID]
    ON [Intesys].[SystemParameter]([SystemParameterID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the parameters for system processes such as number of days past admit/discharge date for trimming pre-admit/inpatient visits OR table name, index name for dbcc/update stats process. It stores parameters that are used by system processes (backend services).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SystemParameter';

