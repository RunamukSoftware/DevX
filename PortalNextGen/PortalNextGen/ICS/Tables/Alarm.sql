CREATE TABLE [ICS].[Alarm] (
    [AlarmID]             INT           IDENTITY (1, 1) NOT NULL,
    [ParameterID]         INT           NOT NULL,
    [SettingViolated]     VARCHAR (25)  NOT NULL,
    [ViolatingValue]      VARCHAR (25)  NOT NULL,
    [BeginDateTime]       DATETIME2 (7) NOT NULL,
    [EndDateTime]         DATETIME2 (7) NULL,
    [StatusValue]         INT           NOT NULL,
    [StatusTimeout]       TINYINT       NULL,
    [DetectionTimestamp]  DATETIME2 (7) NOT NULL,
    [Acknowledged]        BIT           NOT NULL,
    [PriorityWeightValue] INT           NOT NULL,
    [AcquiredDateTime]    DATETIME2 (7) NOT NULL,
    [Leads]               INT           NOT NULL,
    [WaveformFeedTypeID]  INT           NOT NULL,
    [FeedTypeID]          INT           NOT NULL,
    [IDEnumValue]         INT           NOT NULL,
    [EnumGroupID]         INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_Alarm_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Alarm_AlarmID] PRIMARY KEY CLUSTERED ([AlarmID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Alarm_Parameter_ParameterID] FOREIGN KEY ([ParameterID]) REFERENCES [ICS].[Parameter] ([ParameterID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Alarm';

