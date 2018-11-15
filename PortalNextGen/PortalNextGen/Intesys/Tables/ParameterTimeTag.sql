CREATE TABLE [Intesys].[ParameterTimeTag] (
    [ParameterTimeTagID] INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]          INT           NOT NULL,
    [OriginalPatientID]  INT           NULL,
    [PatientChannelID]   INT           NOT NULL,
    [TimeTagType]        INT           NOT NULL,
    [ParamDateTime]      DATETIME2 (7) NOT NULL,
    [Value1]             INT           NULL,
    [Value2]             INT           NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_ParameterTimeTag_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ParameterTimeTag_ParameterTimeTagID] PRIMARY KEY CLUSTERED ([ParameterTimeTagID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ParameterTimeTag_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_ParameterTimeTag_PatientChannel_PatientChannelID] FOREIGN KEY ([PatientChannelID]) REFERENCES [Intesys].[PatientChannel] ([PatientChannelID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ParamTimeTag_PatientID_TimeTagType_PatientChannelID_ParamDateTime]
    ON [Intesys].[ParameterTimeTag]([PatientID] ASC, [TimeTagType] ASC, [PatientChannelID] ASC, [ParamDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_ParameterTimeTag_TimeTagType_PatientID_ParamDateTime]
    ON [Intesys].[ParameterTimeTag]([TimeTagType] ASC, [PatientID] ASC, [ParamDateTime] ASC)
    INCLUDE([Value1], [Value2]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_ParameterTimeTag_PatientID_TimeTagType_ParamDateTime]
    ON [Intesys].[ParameterTimeTag]([PatientID] ASC, [TimeTagType] ASC, [ParamDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores time tag events (lead change events and module status events). Each record is uniquely identified by PatientID, param_type, timetag_type, and param_ft. The data in this table is populated by teh MonitorLoader process.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ParameterTimeTag';

