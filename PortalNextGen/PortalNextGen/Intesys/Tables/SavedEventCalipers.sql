CREATE TABLE [Intesys].[SavedEventCalipers] (
    [SavedEventCalipersID] INT            IDENTITY (1, 1) NOT NULL,
    [PatientID]            INT            NOT NULL,
    [OriginalPatientID]    INT            NULL,
    [EventID]              BIGINT         NOT NULL,
    [ChannelType]          INT            NOT NULL,
    [CaliperType]          INT            NOT NULL,
    [CaliperOrientation]   NVARCHAR (50)  NOT NULL,
    [CaliperText]          NVARCHAR (200) NULL,
    [Caliper_start_ms]     INT            NOT NULL,
    [Caliper_end_ms]       INT            NOT NULL,
    [CaliperTop]           INT            NOT NULL,
    [CaliperBottom]        INT            NOT NULL,
    [FirstCaliperIndex]    INT            NULL,
    [SecondCaliperIndex]   INT            NULL,
    [CreatedDateTime]      DATETIME2 (7)  CONSTRAINT [DF_SavedEventCalipers_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SavedEventCalipers_SavedEventCalipersID] PRIMARY KEY CLUSTERED ([SavedEventCalipersID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_SavedEventCalipers_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_SavedEventCalipers_PatientSavedEvent_PatientID_EventID] FOREIGN KEY ([PatientID], [EventID]) REFERENCES [Intesys].[PatientSavedEvent] ([PatientID], [EventID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SavedEventCalipers_PatientID_EventID_ChannelType_CaliperType]
    ON [Intesys].[SavedEventCalipers]([PatientID] ASC, [EventID] ASC, [ChannelType] ASC, [CaliperType] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventCalipers';

