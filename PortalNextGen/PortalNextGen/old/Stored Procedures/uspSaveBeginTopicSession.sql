CREATE PROCEDURE [old].[uspSaveBeginTopicSession] (@BeginTopicSessionData [old].[utpTopicSession] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        /* In the procedure input, a given session id might be associated with two rows :
        one with the PatientSessionID and one without, in case the topic session update
        is part of the same batched query as the topic session discovery.
        In that case we combine the two rows into one */

        DECLARE @ZippedTopicSessionData AS [old].[utpTopicSession];

        INSERT INTO @ZippedTopicSessionData
            (
                [TopicSessionID],
                [TopicTypeID],
                [TopicInstanceID],
                [DeviceSessionID],
                [PatientSessionID],
                [BeginDateTime]
            )
                    SELECT
                        [Source].[TopicSessionID],
                        [Source].[TopicTypeID],
                        [Source].[TopicInstanceID],
                        [Source].[DeviceSessionID],
                        [DataWithPatientSession].[PatientSessionID],
                        MIN([Source].[BeginDateTime])
                    FROM
                        @BeginTopicSessionData     AS [Source]
                        LEFT OUTER JOIN
                            @BeginTopicSessionData AS [DataWithPatientSession]
                                ON [DataWithPatientSession].[TopicSessionID] = [Source].[TopicSessionID]
                                   AND [DataWithPatientSession].[PatientSessionID] IS NOT NULL
                    GROUP BY
                        [Source].[TopicSessionID],
                        [Source].[TopicTypeID],
                        [Source].[TopicInstanceID],
                        [Source].[DeviceSessionID],
                        [DataWithPatientSession].[PatientSessionID];

        /* If some of the devices have pending sessions, close them 
        Do not close sessions that have no patient session associated
        when the new data provides that patient association */
        UPDATE
            [old].[TopicSession]
        SET
            [EndDateTime] = [x].[BeginDateTime]
        FROM
            (
                SELECT
                    [ts].[TopicSessionID],
                    [dd].[BeginDateTime]
                FROM
                    [old].[TopicSession] AS [ts]
                    INNER JOIN
                        (
                            SELECT
                                [Source].[TopicInstanceID],
                                [Source].[PatientSessionID],
                                [Source].[BeginDateTime],
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [Source].[TopicInstanceID]
                                                   ORDER BY
                                                       [Source].[BeginDateTime] ASC
                                                  ) AS [RowNumber]
                            FROM
                                @ZippedTopicSessionData AS [Source]
                        )                AS [dd]
                            ON [ts].[TopicInstanceID] = [dd].[TopicInstanceID]
                               AND [dd].[RowNumber] = 1
                               AND [ts].[EndDateTime] IS NULL
                               AND (
                                       [dd].[PatientSessionID] IS NULL
                                       OR [ts].[PatientSessionID] IS NOT NULL
                                   )
            ) AS [x]
        WHERE
            [TopicSession].[TopicSessionID] = [x].[TopicSessionID];

        UPDATE
            [old].[PatientSession]
        SET
            [EndDateTime] = [x].[BeginDateTime]
        FROM
            -- [x] associates PatientSessionIDs of dangling sessions to the BeginTime of the incoming TopicSessions.
            (
                SELECT
                    [ps].[PatientSessionID],
                    [ztsd].[BeginDateTime]
                FROM
                    @ZippedTopicSessionData    AS [ztsd]
                    INNER JOIN
                        [old].[TopicSession]   AS [ts]
                            ON [ts].[TopicSessionID] <> [ztsd].[TopicSessionID]
                               AND [ts].[TopicInstanceID] = [ztsd].[TopicInstanceID]
                    INNER JOIN
                        [old].[PatientSession] AS [ps]
                            ON [ps].[PatientSessionID] = [ts].[PatientSessionID]
                               AND [ps].[PatientSessionID] <> [ztsd].[PatientSessionID]
                WHERE
                    [ps].[EndDateTime] IS NULL
            ) AS [x]
        WHERE
            [PatientSession].[PatientSessionID] = [x].[PatientSessionID];

        -- Insert the new sessions
        INSERT INTO [old].[TopicSession]
            (
                [TopicSessionID],
                [TopicTypeID],
                [TopicInstanceID],
                [DeviceSessionID],
                [PatientSessionID],
                [BeginDateTime]
            )
                    SELECT
                        [Source].[TopicSessionID],
                        [Source].[TopicTypeID],
                        [Source].[TopicInstanceID],
                        [Source].[DeviceSessionID],
                        [Source].[PatientSessionID],
                        [Source].[BeginDateTime]
                    FROM
                        @ZippedTopicSessionData AS [Source]
                    WHERE
                        [Source].[TopicSessionID] NOT IN (
                                                             SELECT
                                                                 [ts].[TopicSessionID]
                                                             FROM
                                                                 [old].[TopicSession] AS [ts]
                                                         );

        /* Deal with the sessions for which the closing query arrives
        before the opening query. In this case we have no begin time
        but we do have an endtime.  Fill in the rest of the info */
        UPDATE
            [old].[TopicSession]
        SET
            [TopicTypeID] = [Updates].[TopicTypeID],
            [TopicInstanceID] = [Updates].[TopicInstanceID],
            [DeviceSessionID] = [Updates].[DeviceSessionID],
            [PatientSessionID] = [Updates].[PatientSessionID],
            [BeginDateTime] = [Updates].[BeginDateTime]
        FROM
            (
                SELECT
                    [Target].[TopicSessionID],
                    [Source].[TopicTypeID],
                    [Source].[TopicInstanceID],
                    [Source].[DeviceSessionID],
                    [Source].[PatientSessionID],
                    [Source].[BeginDateTime]
                FROM
                    [old].[TopicSession]        AS [Target]
                    INNER JOIN
                        @ZippedTopicSessionData AS [Source]
                            ON [Target].[TopicSessionID] = [Source].[TopicSessionID]
                WHERE
                    [Target].[BeginDateTime] IS NULL
                    AND [Target].[EndDateTime] IS NOT NULL
            ) AS [Updates]
        WHERE
            [Updates].[TopicSessionID] = [TopicSession].[TopicSessionID];

        /* Log the PatientSessionID for sessions that are opened but waiting for
        a patient session ID.  These sessions have a begin time but no patient session id */
        UPDATE
            [old].[TopicSession]
        SET
            [PatientSessionID] = [Updates].[PatientSessionID]
        FROM
            (
                SELECT
                    [Target].[TopicSessionID],
                    [Source].[PatientSessionID]
                FROM
                    [old].[TopicSession]        AS [Target]
                    INNER JOIN
                        @ZippedTopicSessionData AS [Source]
                            ON [Target].[TopicSessionID] = [Source].[TopicSessionID]
                WHERE
                    [Target].[BeginDateTime] IS NOT NULL
                    AND [Target].[PatientSessionID] IS NULL
            ) AS [Updates]
        WHERE
            [Updates].[TopicSessionID] = [TopicSession].[TopicSessionID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveBeginTopicSession';

