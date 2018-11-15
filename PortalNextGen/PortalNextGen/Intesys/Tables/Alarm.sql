CREATE TABLE [Intesys].[Alarm] (
    [AlarmID]           INT            IDENTITY (1, 1) NOT NULL,
    [PatientID]         INT            NOT NULL,
    [OriginalPatientID] INT            NULL,
    [PatientChannelID]  INT            NOT NULL,
    [StartDateTime]     DATETIME2 (7)  NOT NULL,
    [EndDateTime]       DATETIME2 (7)  NULL,
    [AlarmCode]         NVARCHAR (50)  NOT NULL,
    [AlarmDescription]  NVARCHAR (255) NOT NULL,
    [Removed]           TINYINT        NOT NULL,
    [AlarmLevel]        TINYINT        NOT NULL,
    [IsStacked]         CHAR (1)       NOT NULL,
    [IsLevelChanged]    CHAR (1)       NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)  CONSTRAINT [DF_Alarm_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Alarm_AlarmID] PRIMARY KEY CLUSTERED ([AlarmID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Alarm_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_Alarm_PatientChannel_PatientChannelID] FOREIGN KEY ([PatientChannelID]) REFERENCES [Intesys].[PatientChannel] ([PatientChannelID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Alarm_PatientID_PatientChannelID]
    ON [Intesys].[Alarm]([PatientID] ASC, [PatientChannelID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Alarm_PatientChannelID_StartDateTime]
    ON [Intesys].[Alarm]([PatientChannelID] ASC, [StartDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Alarm_AlarmID_PatientID_PatientChannelID]
    ON [Intesys].[Alarm]([AlarmID] ASC, [PatientID] ASC, [PatientChannelID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores alarm events collected from the monitor. Each record is uniquely identified by AlarmID. The data in this table is populated by the MonitorLoader process.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying an alarm', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'AlarmID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID indentifying a patient. Foreign key to the int_patient table', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Original patient ID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying a channel Type. Foreign key to the int_channel_type table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'PatientChannelID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The start time of the alarm', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'StartDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The end date of the alarm', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'EndDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A text value representing the alarm Subtype (ie Vfib).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'AlarmCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The alarm annotation text.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'AlarmDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Alarm severity level', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'AlarmLevel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates if alarm Type has changed during it''s lifetime', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'IsStacked';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates if alarm level has changed during it''s lifetime', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Alarm', @level2type = N'COLUMN', @level2name = N'IsLevelChanged';

