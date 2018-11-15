CREATE TABLE [dbo].[GeneralAlarmsData_TemporalHistory] (
    [AlarmId]             UNIQUEIDENTIFIER NOT NULL,
    [StatusTimeout]       TINYINT          NULL,
    [StartDateTime]       DATETIME         NOT NULL,
    [EndDateTime]         DATETIME         NULL,
    [StatusValue]         INT              NOT NULL,
    [PriorityWeightValue] INT              NOT NULL,
    [AcquiredDateTimeUTC] DATETIME         NOT NULL,
    [Leads]               INT              NOT NULL,
    [WaveformFeedTypeId]  UNIQUEIDENTIFIER NOT NULL,
    [TopicSessionId]      UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]          UNIQUEIDENTIFIER NOT NULL,
    [IDEnumValue]         INT              NOT NULL,
    [EnumGroupId]         UNIQUEIDENTIFIER NOT NULL,
    [Sequence]            BIGINT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7)    NOT NULL,
    [SysStartTime]        DATETIME2 (7)    NOT NULL,
    [SysEndTime]          DATETIME2 (7)    NOT NULL
);




GO


GO
CREATE CLUSTERED INDEX [CL_GeneralAlarmsData_TemporalHistory_SysEndTime_SysStartTime_Sequence]
    ON [dbo].[GeneralAlarmsData_TemporalHistory]([SysEndTime] ASC, [SysStartTime] ASC) WITH (FILLFACTOR = 100);

