CREATE TABLE [Intesys].[EventConfiguration] (
    [EventConfigurationID]       INT           IDENTITY (1, 1) NOT NULL,
    [AlarmNotificationMode]      INT           NOT NULL,
    [VitalsUpdateInterval]       INT           NOT NULL,
    [AlarmPollingInterval]       INT           NOT NULL,
    [PortNumber]                 INT           NOT NULL,
    [TrackAlarmExecution]        TINYINT       NULL,
    [TrackVitalsUpdateExecution] TINYINT       NULL,
    [CreatedDateTime]            DATETIME2 (7) CONSTRAINT [DF_EventConfiguration_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_EventConfiguration_EventConfigurationID] PRIMARY KEY CLUSTERED ([EventConfigurationID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the information about configuration of alarm handling events.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Alarm mode', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration', @level2type = N'COLUMN', @level2name = N'AlarmNotificationMode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Interval (min.) of updating', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration', @level2type = N'COLUMN', @level2name = N'VitalsUpdateInterval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Interval (min.) of polling information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration', @level2type = N'COLUMN', @level2name = N'AlarmPollingInterval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Port number', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration', @level2type = N'COLUMN', @level2name = N'PortNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag: 1 = alarm execution', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration', @level2type = N'COLUMN', @level2name = N'TrackAlarmExecution';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag: 1 = update vital  signs', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EventConfiguration', @level2type = N'COLUMN', @level2name = N'TrackVitalsUpdateExecution';

