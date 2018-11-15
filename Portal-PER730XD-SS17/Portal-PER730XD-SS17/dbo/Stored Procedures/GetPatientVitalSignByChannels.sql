CREATE PROCEDURE [dbo].[GetPatientVitalSignByChannels]
    (
     @PatientId UNIQUEIDENTIFIER,
     @ChannelTypes [dbo].[StringList] READONLY
    )
AS
BEGIN
    DECLARE @VitalValue [dbo].[VitalValues];

    INSERT  INTO @VitalValue
    SELECT
        [vital_value]
    FROM
        [dbo].[int_vital_live]
    WHERE
        [patient_id] = @PatientId;      
 
    ((SELECT
        [TopicFeedTypes].[FeedTypeId] AS [PATIENT_CHANNEL_ID],
        [VitalsAll].[GdsCode] AS [GDS_CODE],
        [VitalsAll].[Value] AS [VITAL_VALUE],
        [int_channel_vital].[format_string] AS [FORMAT_STRING]
      FROM
        @ChannelTypes AS [CHT]
        INNER JOIN [dbo].[TopicFeedTypes] ON [TopicFeedTypes].[FeedTypeId] = [CHT].[Item]
        INNER JOIN [dbo].[int_channel_vital] ON [int_channel_vital].[channel_type_id] = [TopicFeedTypes].[ChannelTypeId]
        INNER JOIN (SELECT
                        ROW_NUMBER() OVER (PARTITION BY [LiveData].[TopicInstanceId], [GdsCode] ORDER BY [TimestampUTC] DESC) AS [RowNumber],
                        [LiveData].[FeedTypeId],
                        [LiveData].[TopicInstanceId],
                        [LiveData].[Name],
                        [LiveData].[Value],
                        [GdsCode],
                        [GdsCodeMap].[CodeId]
                    FROM
                        [dbo].[LiveData] WITH (SNAPSHOT)
                        INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[TopicInstanceId] = [LiveData].[TopicInstanceId]
                                                            AND [TopicSessions].[EndTimeUTC] IS NULL
                        INNER JOIN [dbo].[GdsCodeMap] ON [GdsCodeMap].[FeedTypeId] = [LiveData].[FeedTypeId]
                                                         AND [GdsCodeMap].[Name] = [LiveData].[Name]
                    WHERE
                        [TopicSessions].[Id] IN (SELECT
                                                    [TopicSessionId]
                                                 FROM
                                                    [dbo].[v_PatientTopicSessions]
                                                 WHERE
                                                    [PatientId] = @PatientId)
                   ) AS [VitalsAll] ON [VitalsAll].[CodeId] = [int_channel_vital].[gds_cid]
      WHERE
        [VitalsAll].[RowNumber] = 1
     )
     UNION ALL
     (SELECT
        [PATCHL].[channel_type_id] AS [PATIENT_CHANNEL_ID],
        [MSCODE].[code] AS [GDS_CODE],
        [LiveValue].[ResultValue] AS [VITAL_VALUE],
                --TODATETIMEOFFSET (convert(datetime,stuff(stuff(stuff(LiveTime.ResultTime, 9, 0, ' '), 12, 0, ':'), 15, 0, ':')) ,DATENAME(tz, SYSDATETIMEOFFSET()))  AS COLLECT_DT,
        [CHVIT].[format_string] AS [FORMAT_STRING]
      FROM
        [dbo].[int_patient_channel] AS [PATCHL]
        INNER JOIN [dbo].[int_channel_vital] AS [CHVIT] ON [PATCHL].[channel_type_id] = [CHVIT].[channel_type_id]
                                                           AND [PATCHL].[active_sw] = 1
        INNER JOIN [dbo].[int_vital_live] AS [VITALRES] ON [PATCHL].[patient_id] = [VITALRES].[patient_id]
        LEFT OUTER JOIN (SELECT
                            [idx],
                            [value],
                            SUBSTRING([value], CHARINDEX('=', [value]) + 1, LEN([value])) AS [ResultValue],
                            CONVERT(INT, SUBSTRING([value], 0, CHARINDEX('=', [value]))) AS [GdsCodeId]
                         FROM
                            [dbo].[fn_Vital_Merge]((@VitalValue), '|')
                        ) AS [LiveValue] ON [LiveValue].[GdsCodeId] = [CHVIT].[gds_cid]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [MSCODE] ON [MSCODE].[code_id] = [CHVIT].[gds_cid]
                                                             AND [MSCODE].[code] IS NOT NULL
      WHERE
        [PATCHL].[patient_id] = @PatientId
        AND [PATCHL].[channel_type_id] IN (SELECT
                                            [Item]
                                           FROM
                                            @ChannelTypes)
        AND [PATCHL].[active_sw] = 1
        AND [LiveValue].[idx] IS NOT NULL
     )
    )
    ORDER BY
        VITAL_VALUE;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientVitalSignByChannels';

