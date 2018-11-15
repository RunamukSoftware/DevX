CREATE TABLE [dbo].[ParameterType] (
    [ParameterTypeID]   BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [ParameterTypeName] VARCHAR (50)  NOT NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_ParameterType_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK9] PRIMARY KEY NONCLUSTERED ([ParameterTypeID] ASC) WITH (FILLFACTOR = 100)
);

