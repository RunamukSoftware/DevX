CREATE TABLE [Intesys].[PatientChannel] (
    [PatientChannelID]  INT           IDENTITY (1, 1) NOT NULL,
    [PatientMonitorID]  INT           NOT NULL,
    [PatientID]         INT           NOT NULL,
    [OriginalPatientID] INT           NULL,
    [MonitorID]         INT           NOT NULL,
    [ModuleNumber]      INT           NOT NULL,
    [ChannelNumber]     INT           NOT NULL,
    [ChannelTypeID]     INT           NOT NULL,
    [CollectionSwitch]  BIT           NOT NULL,
    [ActiveSwitch]      BIT           NOT NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_PatientChannel_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientChannel_PatientChannelID] PRIMARY KEY CLUSTERED ([PatientChannelID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientChannel_ChannelType_ChannelTypeID] FOREIGN KEY ([ChannelTypeID]) REFERENCES [Intesys].[ChannelType] ([ChannelTypeID]),
    CONSTRAINT [FK_PatientChannel_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientChannel_PatientChannelID_ChannelTypeID]
    ON [Intesys].[PatientChannel]([PatientChannelID] ASC, [ChannelTypeID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientChannel_PatientID_MonitorID_ModuleNumber_ChannelNumber_PatientMonitorID_ChannelTypeID]
    ON [Intesys].[PatientChannel]([PatientID] ASC, [MonitorID] ASC, [ModuleNumber] ASC, [ChannelNumber] ASC, [PatientMonitorID] ASC, [ChannelTypeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains channel data active for a given patient. Each record is uniquely identified by the PatientChannelID, MonitorID and PatientID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientChannel';

