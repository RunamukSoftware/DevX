CREATE PROCEDURE [HL7].[uspHL7GetObservationsByPatientID]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [Code].[CodeID],
            [Code].[Code],
            [Code].[ShortDescription] AS [Description],
            [Code].[KeystoneCode]     AS [Units],
            [ir].[ResultValue],
            [ir].[ValueTypeCode],
            [ir].[StatusCodeID]       AS [ResultStatus],
            [ir].[Probability],
            [ir].[ReferenceRangeID]   AS [ReferenceRange],
            [ir].[AbnormalNatureCode],
            [ir].[AbnormalCode],
            [ir].[ResultDateTime]
        FROM
            [Intesys].[Result]                AS [ir]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [Code]
                    ON [ir].[TestCodeID] = [Code].[CodeID]
        WHERE
            [ir].[PatientID] = @PatientID
            AND [ir].[ResultDateTime]
            BETWEEN @StartDateTime AND @EndDateTime
            AND [ir].[ResultValue] IS NOT NULL
        UNION ALL
        SELECT
            [gdscm].[CodeID],
            [gdscm].[GlobalDataSystemCode],
            [gdscm].[Description],
            [gdscm].[Units],
            [v].[Value],
            N'',
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            [v].[Timestamp]
        FROM
            [old].[Vital] AS [v]
            INNER JOIN
                [old].[GlobalDataSystemCodeMap] AS [gdscm]
                    ON [gdscm].[FeedTypeID] = [v].[FeedTypeID]
                       AND [gdscm].[Name] = [v].[Name]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [v].[TopicSessionID] = [vpts].[TopicSessionID]
        WHERE
            [PatientID] = @PatientID
            AND [v].[Timestamp]
            BETWEEN @StartDateTime AND @EndDateTime
        ORDER BY
            [Code] ASC,
            [ir].[ResultDateTime] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retreive the patient observations by patient id.  @PatientID is mandatory.  If @StartDateTime and @EndDateTime are passed it will return the observations between the given time span', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspHL7GetObservationsByPatientID';

