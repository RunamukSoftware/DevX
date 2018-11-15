CREATE TABLE [Intesys].[PrintJobEnhancedTelemetryVital] (
    [PrintJobEnhancedTelemetryVitalID] INT            NOT NULL,
    [PatientID]                        INT            NOT NULL,
    [TopicSessionID]                   INT            NOT NULL,
    [GlobalDataSystemCode]             VARCHAR (80)   NOT NULL,
    [Name]                             NVARCHAR (255) NOT NULL,
    [Value]                            NVARCHAR (255) NOT NULL,
    [ResultDateTime]                   DATETIME2 (7)  NOT NULL,
    [CreatedDateTime]                  DATETIME2 (7)  CONSTRAINT [DF_PrintJobEnhancedTelemetryVital_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintJobEnhancedTelemetryVital_PrintJobEnhancedTelemetryVitalID] PRIMARY KEY CLUSTERED ([PrintJobEnhancedTelemetryVitalID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintJobEnhancedTelemetryVital_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_PrintJobEnhancedTelemetryVital_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryVital_PatientID_TopicSessionID_GlobalDataSystemCode_Name_Value_ResultTime]
    ON [Intesys].[PrintJobEnhancedTelemetryVital]([PatientID] ASC, [TopicSessionID] ASC)
    INCLUDE([GlobalDataSystemCode], [Name], [Value], [ResultDateTime]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PrintJobEnhancedTelemetryVital';

