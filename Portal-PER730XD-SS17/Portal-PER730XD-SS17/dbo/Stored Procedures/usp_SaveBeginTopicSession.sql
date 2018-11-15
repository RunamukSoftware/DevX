CREATE PROCEDURE [dbo].[usp_SaveBeginTopicSession]
    (
     @beginTopicSessionData [dbo].TopicSessionDataType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    /* In the procedure input, a given session id might be associated with two rows :
       one with the PatientSessionId and one without, in case the topic session update
       is part of the same batched query as the topic session discovery.
       In that case we combine the two rows into one */

    DECLARE @zippedTopicSessionData AS [dbo].[TopicSessionDataType];

    INSERT  INTO @zippedTopicSessionData
            ([Id],
             [TopicTypeId],
             [TopicInstanceId],
             [DeviceSessionId],
             [PatientSessionId],
             [BeginTimeUTC]
            )
    SELECT
        [Source].[Id],
        [Source].[TopicTypeId],
        [Source].[TopicInstanceId],
        [Source].[DeviceSessionId],
        [DataWithPatientSession].[PatientSessionId],
        MIN([Source].[BeginTimeUTC])
    FROM
        @beginTopicSessionData AS [Source]
        LEFT OUTER JOIN @beginTopicSessionData AS [DataWithPatientSession] ON [DataWithPatientSession].[Id] = [Source].[Id]
                                                                              AND [DataWithPatientSession].[PatientSessionId] IS NOT NULL
    GROUP BY
        [Source].[Id],
        [Source].[TopicTypeId],
        [Source].[TopicInstanceId],
        [Source].[DeviceSessionId],
        [DataWithPatientSession].[PatientSessionId];

    /* If some of the devices have pending sessions, close them */
    /* Do not close sessions that have no patient session associated
       when the new data provides that patient association */
    UPDATE
        [dbo].[TopicSessions]
    SET
        [TopicSessions].[EndTimeUTC] = [x].[BeginTimeUTC]
    FROM
        (SELECT
            [ss].[Id],
            [dd].[BeginTimeUTC]
         FROM
            [dbo].[TopicSessions] AS [ss]
            INNER JOIN (SELECT
                            [TopicInstanceId],
                            [PatientSessionId],
                            [BeginTimeUTC],
                            ROW_NUMBER() OVER (PARTITION BY [TopicInstanceId] ORDER BY [BeginTimeUTC] ASC) AS [RowNumber]
                        FROM
                            @zippedTopicSessionData AS [Source]
                       ) AS [dd] ON [ss].[TopicInstanceId] = [dd].[TopicInstanceId]
                                    AND [dd].[RowNumber] = 1
                                    AND [ss].[EndTimeUTC] IS NULL
                                    AND ([dd].[PatientSessionId] IS NULL
                                    OR [ss].[PatientSessionId] IS NOT NULL
                                    )
        ) AS [x]
    WHERE
        [TopicSessions].[Id] = [x].[Id];

	UPDATE
		[dbo].[PatientSessions]
	SET
		[PatientSessions].[EndTimeUTC] = [x].[BeginTimeUTC]
	FROM
		-- [x] associates PatientSessionIds of dangling sessions to the begintime of the incoming topicsessions.
		(
			SELECT [ps].[Id], [ztsd].[BeginTimeUTC]
			FROM @zippedTopicSessionData AS [ztsd]
			INNER JOIN [dbo].[TopicSessions] AS [ts]
				ON [ts].[Id] <> [ztsd].[Id]
				AND [ts].[TopicInstanceId] = [ztsd].[TopicInstanceId]
			INNER JOIN [dbo].[PatientSessions] AS [ps]
				ON [ps].[Id] = [ts].[PatientSessionId]
				AND [ps].[Id] <> [ztsd].[PatientSessionId]
			WHERE [ps].[EndTimeUTC] IS NULL
		) AS [x]
	WHERE
		[PatientSessions].[Id] = [x].[Id];

    -- Insert the new sessions
    INSERT  INTO [dbo].[TopicSessions]
            ([Id],
             [TopicTypeId],
             [TopicInstanceId],
             [DeviceSessionId],
             [PatientSessionId],
             [BeginTimeUTC]
            )
    SELECT
        [Source].[Id],
        [Source].[TopicTypeId],
        [Source].[TopicInstanceId],
        [Source].[DeviceSessionId],
        [Source].[PatientSessionId],
        [Source].[BeginTimeUTC]
    FROM
        @zippedTopicSessionData AS [Source]
    WHERE
        [Source].[Id] NOT IN (SELECT
                                [Id]
                              FROM
                                [dbo].[TopicSessions]);

    /* Deal with the sessions for which the closing query arrives
       before the opening query. In this case we have no begin time
       but we do have an endtime.  Fill in the rest of the info */
    UPDATE
        [dbo].[TopicSessions]
    SET
        [TopicSessions].[TopicTypeId] = [Updates].[TopicTypeId],
        [TopicSessions].[TopicInstanceId] = [Updates].[TopicInstanceId],
        [TopicSessions].[DeviceSessionId] = [Updates].[DeviceSessionId],
        [TopicSessions].[PatientSessionId] = [Updates].[PatientSessionId],
        [TopicSessions].[BeginTimeUTC] = [Updates].[BeginTimeUTC]
    FROM
        (SELECT
            [Target].[Id],
            [Source].[TopicTypeId],
            [Source].[TopicInstanceId],
            [Source].[DeviceSessionId],
            [Source].[PatientSessionId],
            [Source].[BeginTimeUTC]
         FROM
            [dbo].[TopicSessions] AS [Target]
            INNER JOIN @zippedTopicSessionData AS [Source] ON [Target].[Id] = [Source].[Id]
         WHERE
            [Target].[BeginTimeUTC] IS NULL
            AND [Target].[EndTimeUTC] IS NOT NULL
        ) AS [Updates]
    WHERE
        [Updates].[Id] = [TopicSessions].[Id];

    /* Log the PatientSessionId for sessions that are opened but waiting for
       a patient session Id.  These sessions have a begin time but no patient session id */
    UPDATE
        [dbo].[TopicSessions]
    SET
        [TopicSessions].[PatientSessionId] = [Updates].[PatientSessionId]
    FROM
        (SELECT
            [Target].[Id],
            [Source].[PatientSessionId]
         FROM
            [dbo].[TopicSessions] AS [Target]
            INNER JOIN @zippedTopicSessionData AS [Source] ON [Target].[Id] = [Source].[Id]
         WHERE
            [Target].[BeginTimeUTC] IS NOT NULL
            AND [Target].[PatientSessionId] IS NULL
        ) AS [Updates]
    WHERE
        [Updates].[Id] = [TopicSessions].[Id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveBeginTopicSession';

