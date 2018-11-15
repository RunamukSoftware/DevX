CREATE PROCEDURE [old].[uspGetMinMaxPatientTimes]
    (
        @PatientID INT,
        @GetAll    BIT = 1
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@GetAll = 0)
            BEGIN
                SELECT
                    MIN([iw].[StartDateTime]) AS [StartDateTime],
                    MAX([iw].[EndDateTime])   AS [EndDateTime]
                FROM
                    [Intesys].[PatientChannel] AS [ipc]
                    INNER JOIN
                        [Intesys].[Waveform]   AS [iw]
                            ON [ipc].[PatientChannelID] = [iw].[PatientChannelID]
                WHERE
                    [ipc].[PatientID] = @PatientID;
            END;
        ELSE
            BEGIN
                SELECT
                    MIN([ComboWaveform].[StartDateTime]) AS [StartDateTime],
                    MAX([ComboWaveform].[EndDateTime])   AS [EndDateTime]
                FROM
                    (
                        SELECT
                            MIN([wd].[StartDateTime]) AS [StartDateTime],
                            MAX([wd].[EndDateTime])   AS [EndDateTime]
                        FROM
                            [old].[Waveform]         AS [wd]
                            INNER JOIN
                                [old].[TopicSession] AS [ts]
                                    ON [wd].[TopicSessionID] = [ts].[TopicSessionID]
                        WHERE
                            [ts].[PatientSessionID] IN (
                                                           SELECT
                                                               [psm].[PatientSessionID]
                                                           FROM
                                                               [old].[PatientSessionMap] AS [psm]
                                                               INNER JOIN
                                                                   (
                                                                       SELECT
                                                                           MAX([psm2].[PatientSessionMapID]) AS [MaxSeq]
                                                                       FROM
                                                                           [old].[PatientSessionMap] AS [psm2]
                                                                       GROUP BY
                                                                           [psm2].[PatientSessionID]
                                                                   )                     AS [PatientSessionMaxSeq]
                                                                       ON [psm].[PatientSessionMapID] = [PatientSessionMaxSeq].[MaxSeq]
                                                           WHERE
                                                               [psm].[PatientID] = @PatientID
                                                       )
                        UNION ALL
                        SELECT
                            MIN([iw].[StartDateTime])  AS [StartDateTime],
                            MAX([iw].[EndDateTime])    AS [EndDateTime]
                        FROM
                            [Intesys].[PatientChannel] AS [ipc]
                            INNER JOIN
                                [Intesys].[Waveform]   AS [iw]
                                    ON [ipc].[PatientChannelID] = [iw].[PatientChannelID]
                        WHERE
                            [ipc].[PatientID] = @PatientID
                    ) AS [ComboWaveform];
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the minimum and maximum patient (DateTime) times from waveform data.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetMinMaxPatientTimes';

