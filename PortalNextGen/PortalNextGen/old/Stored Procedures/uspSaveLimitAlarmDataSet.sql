CREATE PROCEDURE [old].[uspSaveLimitAlarmDataSet] (@LimitAlarm [old].[utpLimitAlarm] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[AlarmStatus]
            (
                [AlarmID],
                [StatusValue],
                [AcquiredDateTime],
                [Leads],
                [WaveformFeedTypeID],
                [TopicSessionID],
                [FeedTypeID],
                [IDEnumValue],
                [EnumGroupID]
            )
                    SELECT
                        [AlarmID],
                        [StatusValue],
                        [AcquiredDateTime],
                        [Leads],
                        [WaveformFeedTypeID],
                        [TopicSessionID],
                        [FeedTypeID],
                        [IDEnumValue],
                        [EnumGroupID]
                    FROM
                        @LimitAlarm
                    WHERE
                        StartDateTime IS NULL;

        MERGE INTO [old].[LimitAlarm] AS [Dest]
        USING
            (
                SELECT
                    [StartingUpdatesSequence].[AlarmID],
                    [StartingUpdatesSequence].[SettingViolated],
                    [StartingUpdatesSequence].[ViolatingValue],
                    [StartingUpdatesSequence].StartDateTime,
                    ISNULL([EndingUpdatesSequence].[EndDateTime], [ts].[EndDateTime]) AS [EndDateTime],
                    [StartingUpdatesSequence].[StatusValue],
                    [StartingUpdatesSequence].[DetectionTimestamp],
                    [StartingUpdatesSequence].[Acknowledged],
                    [StartingUpdatesSequence].[PriorityWeightValue],
                    [StartingUpdatesSequence].[AcquiredDateTime],
                    [StartingUpdatesSequence].[Leads],
                    [StartingUpdatesSequence].[WaveformFeedTypeID],
                    [StartingUpdatesSequence].[TopicSessionID],
                    [StartingUpdatesSequence].[FeedTypeID],
                    [StartingUpdatesSequence].[IDEnumValue],
                    [StartingUpdatesSequence].[EnumGroupID]
                FROM
                    (
                        SELECT
                            [lad1].[AlarmID],
                            [lad1].[SettingViolated],
                            [lad1].[ViolatingValue],
                            [lad1].StartDateTime,
                            [lad1].[StatusValue],
                            [lad1].[DetectionTimestamp],
                            [lad1].[Acknowledged],
                            [lad1].[PriorityWeightValue],
                            [lad1].[AcquiredDateTime],
                            [lad1].[Leads],
                            [lad1].[WaveformFeedTypeID],
                            [lad1].[TopicSessionID],
                            [lad1].[FeedTypeID],
                            [lad1].[IDEnumValue],
                            [lad1].[EnumGroupID],
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [lad1].[AlarmID]
                                               ORDER BY
                                                   [lad1].[AcquiredDateTime] ASC
                                              ) AS [RowNumber]
                        FROM
                            @LimitAlarm AS [lad1]
                        WHERE
                            [lad1].StartDateTime IS NOT NULL
                    )                        AS [StartingUpdatesSequence]
                    LEFT OUTER JOIN
                        (
                            SELECT
                                [lad2].[AlarmID],
                                [lad2].[EndDateTime],
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [lad2].[AlarmID]
                                                   ORDER BY
                                                       [lad2].[AcquiredDateTime] DESC
                                                  ) AS [RowNumber]
                            FROM
                                @LimitAlarm AS [lad2]
                            WHERE
                                [lad2].[EndDateTime] IS NOT NULL
                        )                    AS [EndingUpdatesSequence]
                            ON [EndingUpdatesSequence].[AlarmID] = [StartingUpdatesSequence].[AlarmID]
                               AND [EndingUpdatesSequence].[RowNumber] = 1
                    LEFT OUTER JOIN
                        [old].[TopicSession] AS [ts]
                            ON [ts].[TopicSessionID] = [StartingUpdatesSequence].[TopicSessionID]
                WHERE
                    [StartingUpdatesSequence].[RowNumber] = 1
            ) AS [src]
        ON [src].[AlarmID] = [Dest].[LimitAlarmID]
        WHEN NOT MATCHED BY TARGET
            THEN INSERT
                     (
                         [LimitAlarmID],
                         [SettingViolated],
                         [ViolatingValue],
                         StartDateTime,
                         [EndDateTime],
                         [StatusValue],
                         [DetectionTimestamp],
                         [Acknowledged],
                         [PriorityWeightValue],
                         [AcquiredDateTime],
                         [Leads],
                         [WaveformFeedTypeID],
                         [TopicSessionID],
                         [FeedTypeID],
                         [IDEnumValue],
                         [EnumGroupID]
                     )
                 VALUES
                     (
                         [src].[AlarmID],
                         [src].[SettingViolated],
                         [src].[ViolatingValue],
                         [src].StartDateTime,
                         [src].[EndDateTime],
                         [src].[StatusValue],
                         [src].[DetectionTimestamp],
                         [src].[Acknowledged],
                         [src].[PriorityWeightValue],
                         [src].[AcquiredDateTime],
                         [src].[Leads],
                         [src].[WaveformFeedTypeID],
                         [src].[TopicSessionID],
                         [src].[FeedTypeID],
                         [src].[IDEnumValue],
                         [src].[EnumGroupID]
                     )
        WHEN MATCHED
            THEN UPDATE SET
                     [Dest].[EndDateTime] = [src].[EndDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveLimitAlarmDataSet';

