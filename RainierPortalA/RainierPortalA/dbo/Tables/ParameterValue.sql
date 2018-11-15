CREATE TABLE [dbo].[ParameterValue] (
    [ParameterValueID] BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [ParameterID]      BIGINT        NOT NULL,
    [Value]            SQL_VARIANT   NOT NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_ParameterValue_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ParameterValue_ParameterValueID] PRIMARY KEY NONCLUSTERED ([ParameterValueID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ParameterValue_Parameter_ParameterID] FOREIGN KEY ([ParameterID]) REFERENCES [dbo].[Parameter] ([ParameterID])
);

