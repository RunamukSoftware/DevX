CREATE PROCEDURE [old].[uspSaveGeneralAlarmsDataSet] (@GeneralAlarmsData [old].[utpGeneralAlarmData] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[AlarmStatus]
            (
                [AlarmID],
                [StatusTimeout],
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
                        [StatusTimeout],
                        [StatusValue],
                        [AcquiredDateTime],
                        [Leads],
                        [WaveformFeedTypeID],
                        [TopicSessionID],
                        [FeedTypeID],
                        [IDEnumValue],
                        [EnumGroupID]
                    FROM
                        @GeneralAlarmsData
                    WHERE
                        StartDateTime IS NULL;

        MERGE INTO [old].[GeneralAlarm] AS [Dest]
        USING
            (
                SELECT
                    [StartingUpdatesSequence].[AlarmID],
                    [StartingUpdatesSequence].[StatusTimeout],
                    [StartingUpdatesSequence].StartDateTime,
                    ISNULL([EndingUpdatesSequence].[EndDateTime], [ts].[EndDateTime]) AS [EndDateTime],
                    [StartingUpdatesSequence].[StatusValue],
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
                            [gad].[AlarmID],
                            [gad].[StatusTimeout],
                            [gad].StartDateTime,
                            [gad].[StatusValue],
                            [gad].[PriorityWeightValue],
                            [gad].[AcquiredDateTime],
                            [gad].[Leads],
                            [gad].[WaveformFeedTypeID],
                            [gad].[TopicSessionID],
                            [gad].[FeedTypeID],
                            [gad].[IDEnumValue],
                            [gad].[EnumGroupID],
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [gad].[AlarmID]
                                               ORDER BY
                                                   [gad].[AcquiredDateTime] ASC
                                              ) AS [RowNumber]
                        FROM
                            @GeneralAlarmsData AS [gad]
                        WHERE
                            [gad].StartDateTime IS NOT NULL
                    )                        AS [StartingUpdatesSequence]
                    LEFT OUTER JOIN
                        (
                            SELECT
                                [gad2].[AlarmID],
                                [gad2].[EndDateTime],
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [gad2].[AlarmID]
                                                   ORDER BY
                                                       [gad2].[AcquiredDateTime] DESC
                                                  ) AS [RowNumber]
                            FROM
                                @GeneralAlarmsData AS [gad2]
                            WHERE
                                [gad2].[EndDateTime] IS NOT NULL
                        )                    AS [EndingUpdatesSequence]
                            ON [EndingUpdatesSequence].[AlarmID] = [StartingUpdatesSequence].[AlarmID]
                               AND [EndingUpdatesSequence].[RowNumber] = 1
                    LEFT OUTER JOIN
                        [old].[TopicSession] AS [ts]
                            ON [StartingUpdatesSequence].[TopicSessionID] = [ts].[TopicSessionID]
                WHERE
                    [StartingUpdatesSequence].[RowNumber] = 1
            ) AS [src]
        ON [src].[AlarmID] = [Dest].[GeneralAlarmID]
        WHEN NOT MATCHED BY TARGET
            THEN INSERT
                     (
                         [GeneralAlarmID],
                         [StatusTimeout],
                         StartDateTime,
                         [EndDateTime],
                         [StatusValue],
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
                         [src].[StatusTimeout],
                         [src].StartDateTime,
                         [src].[EndDateTime],
                         [src].[StatusValue],
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveGeneralAlarmsDataSet';

