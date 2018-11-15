CREATE VIEW [old].[vwLiveVitalsData]
WITH SCHEMABINDING
AS
    SELECT
        [ld].[Name],
        [ld].[Value]        AS [ResultValue],
        [ts].[TopicTypeID],
        [ts].[TopicSessionID],
        [vpts].[PatientID],
        [ts].[TopicInstanceID],
        CASE [ld].[Name]
            WHEN 'T1Value'
                THEN '4.6.'
                     + CAST((1 + CAST([old].[ufnZeroIfBigger](CAST([vdt1].[Value] AS INT), 32767) AS INT)) AS NVARCHAR(15))
                     + '.0'
            WHEN 'T2Value'
                THEN '4.7.'
                     + CAST((1 + CAST([old].[ufnZeroIfBigger](CAST([vdt2].[Value] AS INT), 32767) AS INT)) AS NVARCHAR(15))
                     + '.0'
            WHEN 'lead1Index'
                THEN '2.1.2.0'
            WHEN 'lead2Index'
                THEN '2.2.2.0'
            ELSE
                [GlobalDataSystemMetaData].[Value]
        END                 AS [GlobalDataSystemCode],
        [ld].[Timestamp] AS [DateTimeStamp],
        [ld].[FeedTypeID]
    FROM
        [old].[LiveData]                   AS [ld]
        INNER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicInstanceID] = [ld].[TopicInstanceID]
                   AND [ts].[EndDateTime] IS NULL
        INNER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[vwMetadata]             AS [GlobalDataSystemMetaData]
                ON [GlobalDataSystemMetaData].[TypeID] = [ld].[FeedTypeID]
                   AND [GlobalDataSystemMetaData].[EntityMemberName] = [ld].[Name]
                   AND [GlobalDataSystemMetaData].[Name] = 'GdsCode'
        LEFT OUTER JOIN
            [old].[LiveData]               AS [vdt1]
                ON [ld].[LiveDataID] = [vdt1].[LiveDataID]
                   AND [vdt1].[Name] = 'T1Location'
        LEFT OUTER JOIN
            [old].[LiveData]               AS [vdt2]
                ON [ld].[LiveDataID] = [vdt2].[LiveDataID]
                   AND [vdt2].[Name] = 'T2Location';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLiveVitalsData';

