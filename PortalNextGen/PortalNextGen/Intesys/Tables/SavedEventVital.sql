CREATE TABLE [Intesys].[SavedEventVital] (
    [SavedEventVitalID]    INT            IDENTITY (1, 1) NOT NULL,
    [PatientID]            INT            NOT NULL,
    [EventID]              BIGINT         NOT NULL,
    [GlobalDataSystemCode] NVARCHAR (80)  NOT NULL,
    [ResultDateTime]       DATETIME2 (7)  NULL,
    [ResultValue]          NVARCHAR (200) NULL,
    [CreatedDateTime]      DATETIME2 (7)  CONSTRAINT [DF_SavedEventVital_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SavedEventVital_SavedEventVitalID] PRIMARY KEY CLUSTERED ([SavedEventVitalID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_SavedEventVital_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_SavedEventVital_PatientSavedEvent_PatientID_EventID] FOREIGN KEY ([PatientID], [EventID]) REFERENCES [Intesys].[PatientSavedEvent] ([PatientID], [EventID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SavedEventVital_PatientID_EventID_GlobalDataSystemCode]
    ON [Intesys].[SavedEventVital]([PatientID] ASC, [EventID] ASC, [GlobalDataSystemCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventVital';

