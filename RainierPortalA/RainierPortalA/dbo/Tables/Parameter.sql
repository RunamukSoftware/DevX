CREATE TABLE [dbo].[Parameter] (
    [ParameterID]     BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [ParameterTypeID] BIGINT        NOT NULL,
    [ParameterName]   VARCHAR (255) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Parameter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Parameter_ParameterID] PRIMARY KEY CLUSTERED ([ParameterID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Parameter_ParameterType_ParameterTypeID] FOREIGN KEY ([ParameterTypeID]) REFERENCES [dbo].[ParameterType] ([ParameterTypeID])
);

