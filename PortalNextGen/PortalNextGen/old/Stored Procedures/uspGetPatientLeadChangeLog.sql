CREATE PROCEDURE [old].[uspGetPatientLeadChangeLog]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [PT].[ParamDateTime]  AS [StartDateTime],
            [PT].[Value1]         AS [VALUE1],
            [PT].[Value2]         AS [VALUE2],
            CAST(224 AS SMALLINT) AS [SampleRate]
        FROM
            [Intesys].[ParameterTimeTag] AS [PT]
        WHERE
            [PT].[PatientID] = @PatientID
            AND [PT].[TimeTagType] = 12289
            AND @StartDateTime <= [PT].[ParamDateTime]
            AND @EndDateTime >= [PT].[ParamDateTime]

        -- for now, the lead change log is not used in Enhanced Telemetry (ET)
        /*
    UNION ALL

    SELECT DISTINCT
           [StatusLead1].[FileDateTimeStamp] AS [StartDateTime],
           CAST(NULL AS DATETIME2(7)) AS StartDateTime,
           [StatusLead1].[ResultValue] AS [VALUE1],
           [StatusLead2].[ResultValue] AS [VALUE2],
           [ChannelTypes].[SampleRate] AS [SampleRate]

        FROM
        (
            SELECT [FileDateTimeStamp], [SetID], [TopicSessionID], [TopicTypeID], [PatientID], [MonitorLoaderValue] AS [ResultValue]
                FROM [old].[vwStatusData]
                INNER JOIN [old].[LeadConfiguration] ON [DataLoaderValue] = [ResultValue]
                WHERE [GlobalDataSystemCode]='2.1.2.0' -- Display Lead 1
        ) AS [StatusLead1]

        LEFT OUTER JOIN
        (
            SELECT [SetID], [MonitorLoaderValue] AS [ResultValue]
                FROM [old].[vwStatusData]
                INNER JOIN [old].[LeadConfiguration] ON [DataLoaderValue] = [ResultValue]
                WHERE [GlobalDataSystemCode]='2.2.2.0' -- Display Lead 2
        ) AS [StatusLead2]
            ON [StatusLead1].[SetID] = [StatusLead2].[SetID]

        LEFT OUTER JOIN
        (
            SELECT DISTINCT([TopicTypeID]), [SampleRate]
                FROM [old].[vwLegacyChannelTypes]
        ) AS [ChannelTypes]
            ON [ChannelTypes].[TopicTypeID] = [StatusLead1].[TopicTypeID]

        LEFT OUTER JOIN [old].[vwDiscardedOverlappingWaveformData] AS [Discarded]
            ON [Discarded].[TopicSessionID] = [StatusLead1].[TopicSessionID]
            AND [StatusLead1].[FileDateTimeStamp] BETWEEN [Discarded].[DateTimeStampBegin] AND [Discarded].[DateTimeStampEnd]

        WHERE [StatusLead1].[PatientID] = @PatientID
        AND [StatusLead1].[FileDateTimeStamp] BETWEEN @l_start_ft AND @l_end_ft
        AND [Discarded].[WaveformID] IS NULL
    */
        ORDER BY
            [StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientLeadChangeLog';

