CREATE TABLE [ICS].[Parameter] (
    [ParameterID]         INT           IDENTITY (1, 1) NOT NULL,
    [AcquisitionModuleID] INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_Parameter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Parameter_ParameterID] PRIMARY KEY CLUSTERED ([ParameterID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Parameter_AcquisitionModule_AcquisitionModuleID] FOREIGN KEY ([AcquisitionModuleID]) REFERENCES [ICS].[AcquisitionModule] ([AcquisitionModuleID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Parameter';

