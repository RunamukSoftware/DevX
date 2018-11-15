CREATE PROCEDURE [dbo].[usp_SaveGeneralAlarmsDataSet]
    (
     @GeneralAlarmsData [dbo].GeneralAlarmsDataType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[AlarmsStatusData]
            ([Id],
             [AlarmId],
             [StatusTimeout],
             [StatusValue],
             [AcquiredDateTimeUTC],
             [Leads],
             [WaveformFeedTypeId],
             [TopicSessionId],
             [FeedTypeId],
             [IDEnumValue],
             [EnumGroupId]
            )
    SELECT
        NEWID(),
        [AlarmId],
        [StatusTimeout],
        [StatusValue],
        [AcquiredDateTimeUTC],
        [Leads],
        [WaveformFeedTypeId],
        [TopicSessionId],
        [FeedTypeId],
        [IDEnumValue],
        [EnumGroupId]
    FROM
        @GeneralAlarmsData
    WHERE
        [StartDateTime] IS NULL;

    MERGE INTO [dbo].[GeneralAlarmsData] AS [Dest]
    USING
        (SELECT
            [StartingUpdatesSequence].[AlarmId],
            [StatusTimeout],
            [StartDateTime],
            [EndDateTime] = ISNULL([EndingUpdatesSequence].[EndDateTime], [TopicSessions].[EndTimeUTC]),
            [StatusValue],
            [PriorityWeightValue],
            [AcquiredDateTimeUTC],
            [Leads],
            [WaveformFeedTypeId],
            [TopicSessionId],
            [FeedTypeId],
            [IDEnumValue],
            [EnumGroupId]
         FROM
            (SELECT
                [AlarmId],
                [StatusTimeout],
                [StartDateTime],
                [StatusValue],
                [PriorityWeightValue],
                [AcquiredDateTimeUTC],
                [Leads],
                [WaveformFeedTypeId],
                [TopicSessionId],
                [FeedTypeId],
                [IDEnumValue],
                [EnumGroupId],
                ROW_NUMBER() OVER (PARTITION BY [AlarmId] ORDER BY [AcquiredDateTimeUTC] ASC) AS [RowNumber]
             FROM
                @GeneralAlarmsData
             WHERE
                [StartDateTime] IS NOT NULL
            ) AS [StartingUpdatesSequence]
            LEFT OUTER JOIN (SELECT
                                [AlarmId],
                                [EndDateTime],
                                ROW_NUMBER() OVER (PARTITION BY [AlarmId] ORDER BY [AcquiredDateTimeUTC] DESC) AS [RowNumber]
                             FROM
                                @GeneralAlarmsData
                             WHERE
                                [EndDateTime] IS NOT NULL
                            ) AS [EndingUpdatesSequence] ON [EndingUpdatesSequence].[AlarmId] = [StartingUpdatesSequence].[AlarmId]
                                                            AND [EndingUpdatesSequence].[RowNumber] = 1
            LEFT OUTER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [StartingUpdatesSequence].[TopicSessionId]
         WHERE
            [StartingUpdatesSequence].[RowNumber] = 1
        ) AS [Src]
    ON [Src].[AlarmId] = [Dest].[AlarmId]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT
               ([AlarmId],
                [StatusTimeout],
                [StartDateTime],
                [EndDateTime],
                [StatusValue],
                [PriorityWeightValue],
                [AcquiredDateTimeUTC],
                [Leads],
                [WaveformFeedTypeId],
                [TopicSessionId],
                [FeedTypeId],
                [IDEnumValue],
                [EnumGroupId]
               )
        VALUES ([Src].[AlarmId],
                [Src].[StatusTimeout],
                [Src].[StartDateTime],
                [Src].[EndDateTime],
                [Src].[StatusValue],
                [Src].[PriorityWeightValue],
                [Src].[AcquiredDateTimeUTC],
                [Src].[Leads],
                [Src].[WaveformFeedTypeId],
                [Src].[TopicSessionId],
                [Src].[FeedTypeId],
                [Src].[IDEnumValue],
                [Src].[EnumGroupId]
               )
    WHEN MATCHED THEN
        UPDATE SET
               [Dest].[EndDateTime] = [Src].[EndDateTime];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveGeneralAlarmsDataSet';

