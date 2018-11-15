CREATE PROCEDURE [dbo].[GetPatientLeadChangeLog]
    (
     @patient_id UNIQUEIDENTIFIER,
     @start_ft BIGINT,
     @end_ft BIGINT
    )
AS
BEGIN
    DECLARE @l_patient_id UNIQUEIDENTIFIER = @patient_id;
    DECLARE @l_start_ft BIGINT = @start_ft;
    DECLARE @l_end_ft BIGINT = @end_ft;

    SELECT
        [PT].[param_ft] AS [START_FT],
        [PT].[param_dt] AS [START_DT],
        [PT].[value1] AS [VALUE1],
        [PT].[value2] AS [VALUE2],
        CAST(224 AS SMALLINT) AS [SAMPLE_RATE]
    FROM
        [dbo].[int_param_timetag] AS [PT]
    WHERE
        ([PT].[patient_id] = @l_patient_id)
        AND ([PT].[timetag_type] = 12289)
        AND (@l_start_ft <= [PT].[param_ft])
        AND (@l_end_ft >= [PT].[param_ft])
            
    -- for now, the lead change log is not used in ET
    /*
    UNION ALL
    SELECT DISTINCT
           [StatusLead1].[FileDateTimeStamp] AS [START_FT],
           CAST(NULL AS DATETIME) AS [START_DT],
           [StatusLead1].[ResultValue] AS [VALUE1],
           [StatusLead2].[ResultValue] AS [VALUE2],
           [ChannelTypes].[SampleRate] AS [SAMPLE_RATE]

        FROM
        (
            SELECT [FileDateTimeStamp], [SetId], [TopicSessionId], [TopicTypeId], [PatientId], [MonitorLoaderValue] AS [ResultValue]
                FROM [dbo].[v_StatusData]
                INNER JOIN [dbo].[LeadConfiguration] ON [DataLoaderValue] = [ResultValue]
                WHERE [GdsCode]='2.1.2.0' -- Display Lead 1
        ) AS [StatusLead1]

        LEFT OUTER JOIN
        (
            SELECT [SetId], [MonitorLoaderValue] AS [ResultValue]
                FROM [dbo].[v_StatusData]
                INNER JOIN [dbo].[LeadConfiguration] ON [DataLoaderValue] = [ResultValue]
                WHERE [GdsCode]='2.2.2.0' -- Display Lead 2
        ) AS [StatusLead2]
            ON [StatusLead1].[SetId] = [StatusLead2].[SetId]

        LEFT OUTER JOIN
        (
            SELECT DISTINCT([TopicTypeId]), [SampleRate]
                FROM [dbo].[v_LegacyChannelTypes]
        ) AS [ChannelTypes]
            ON [ChannelTypes].[TopicTypeId] = [StatusLead1].[TopicTypeId]

        LEFT OUTER JOIN [dbo].[v_DiscardedOverlappingWaveformData] AS [Discarded]
            ON [Discarded].[TopicSessionId] = [StatusLead1].[TopicSessionId]
            AND [StatusLead1].[FileDateTimeStamp] BETWEEN [Discarded].[FileTimeStampBeginUTC] AND [Discarded].[FileTimeStampEndUTC]

        WHERE [StatusLead1].[PatientId] = @l_patient_id
        AND [StatusLead1].[FileDateTimeStamp] BETWEEN @l_start_ft AND @l_end_ft
        AND [Discarded].[Id] IS NULL */
    ORDER BY
        [START_FT];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientLeadChangeLog';

