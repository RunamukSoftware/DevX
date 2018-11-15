CREATE TABLE [Intesys].[PatientMonitor] (
    [PatientMonitorID]       INT            IDENTITY (1, 1) NOT NULL,
    [PatientID]              INT            NOT NULL,
    [OriginalPatientID]      INT            NOT NULL,
    [MonitorID]              INT            NOT NULL,
    [MonitorInterval]        INT            NOT NULL,
    [PollingType]            CHAR (1)       NOT NULL,
    [MonitorConnectDateTime] DATETIME2 (7)  NOT NULL,
    [MonitorConnectNumber]   INT            NOT NULL,
    [DisableSwitch]          TINYINT        NOT NULL,
    [LastPollingDateTime]    DATETIME2 (7)  NOT NULL,
    [LastResultDateTime]     DATETIME2 (7)  NOT NULL,
    [LastEpisodicDateTime]   DATETIME2 (7)  NOT NULL,
    [PollStartDateTime]      DATETIME2 (7)  NOT NULL,
    [PollEndDateTime]        DATETIME2 (7)  NOT NULL,
    [LastOutboundDateTime]   DATETIME2 (7)  NOT NULL,
    [MonitorStatus]          CHAR (3)       NOT NULL,
    [MonitorError]           NVARCHAR (255) NOT NULL,
    [EncounterID]            INT            NOT NULL,
    [LiveUntilDateTime]      DATETIME2 (7)  NOT NULL,
    [ActiveSwitch]           BIT            NOT NULL,
    [CreatedDateTime]        DATETIME2 (7)  CONSTRAINT [DF_PatientMonitor_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientMonitor_PatientMonitorID] PRIMARY KEY CLUSTERED ([PatientMonitorID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PatientMonitor_Monitor_MonitorID] FOREIGN KEY ([MonitorID]) REFERENCES [Intesys].[Monitor] ([MonitorID]),
    CONSTRAINT [FK_PatientMonitor_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientMonitor_PatientID_MonitorID_MonitorConnectDateTime]
    ON [Intesys].[PatientMonitor]([PatientID] ASC, [MonitorID] ASC, [MonitorConnectDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PatientMonitor_MonitorID_EncounterID_LastResultDateTime_PatientMonitorID]
    ON [Intesys].[PatientMonitor]([MonitorID] ASC, [EncounterID] ASC)
    INCLUDE([LastResultDateTime], [PatientMonitorID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PatientMonitor_MonitorConnectDateTime_EncounterID]
    ON [Intesys].[PatientMonitor]([MonitorConnectDateTime] ASC)
    INCLUDE([EncounterID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PatientMonitor_EncounterID_MonitorID_LastPollingDateTime_LastResultDateTime_PatientMonitorID]
    ON [Intesys].[PatientMonitor]([EncounterID] ASC, [MonitorID] ASC)
    INCLUDE([LastPollingDateTime], [LastResultDateTime], [PatientMonitorID]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is the key table that tracks what patients are currently connected to monitors. It maintains records ONLY for patients that the gateways believe to be on monitor. It does NOT maintain history of who was connected (that is in the int_encounter table). As the monitor loaders communicate to the monitors through the gateways, this table is kept 100% current with the real-world. Patients are created/updated as necessary. And encounters are created/updated as necessary. Purging this table should have no real consequences because the data will be rebuilt by the loaders (with the exception of any manually overriden collection intervals).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientMonitor';

