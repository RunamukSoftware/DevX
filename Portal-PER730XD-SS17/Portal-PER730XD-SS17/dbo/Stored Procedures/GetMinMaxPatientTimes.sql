CREATE PROCEDURE [dbo].[GetMinMaxPatientTimes]
    (
     @patient_id AS [DPATIENT_ID], -- Should be UNIQUEIDENTIFIER -- TG
     @getAll AS BIT = 1
    )
AS
BEGIN
    DECLARE @l_patient_id UNIQUEIDENTIFIER = CAST(@patient_id AS UNIQUEIDENTIFIER); -- Remove implicit conversion from queries below

    IF (@getAll = 0)
    BEGIN   	
        SELECT
            MIN([start_ft]) AS [START_FT],
            MAX([end_ft]) AS [END_FT],
			MIN([start_dt]) AS [START_DT],
			MAX([end_dt]) AS [END_DT],
			CAST(NULL AS DATETIME) AS [START_UTC],
			CAST(NULL AS DATETIME) AS [END_UTC]
        FROM
            [dbo].[int_patient_channel] AS [ipc]
            INNER JOIN [dbo].[int_waveform] AS [iw]
                ON [ipc].[patient_channel_id] = [iw].[patient_channel_id]
        WHERE
            [iw].[patient_id] = @l_patient_id;
    END;
    ELSE
    BEGIN 
        SELECT
            MIN([ComboWaveform].[START_FT]) AS [START_FT],
            MAX([ComboWaveform].[END_FT]) AS [END_FT],
			MIN([ComboWaveform].[START_DT]) AS [START_DT],
			MAX([ComboWaveform].[END_DT]) AS [END_DT],
			MIN([ComboWaveform].[START_UTC]) AS [START_UTC],
			MAX([ComboWaveform].[END_UTC]) AS [END_UTC]
        FROM
            (SELECT
				CAST(NULL AS BIGINT) AS [START_FT],
				CAST(NULL AS BIGINT) AS [END_FT],
				CAST(NULL AS DATETIME) AS [START_DT],
				CAST(NULL AS DATETIME) AS [END_DT],
                MIN([wd].[StartTimeUTC]) AS [START_UTC],
                MAX([wd].[EndTimeUTC]) AS [END_UTC]
             FROM
                [dbo].[WaveformData] AS [wd]
                INNER JOIN [dbo].[TopicSessions] AS [ts]
                    ON [wd].[TopicSessionId] = [ts].[Id]
             WHERE
                [ts].[PatientSessionId] IN (SELECT
                                                [psm].[PatientSessionId]
                                            FROM
                                                [dbo].[PatientSessionsMap] AS [psm]
                                                INNER JOIN (SELECT
                                                                MAX([psm2].[Sequence]) AS [MaxSeq]
                                                            FROM
                                                                [dbo].[PatientSessionsMap] AS [psm2]
                                                            GROUP BY
                                                                [psm2].[PatientSessionId]
                                                           ) AS [PatientSessionMaxSeq]
                                                    ON [psm].[Sequence] = [PatientSessionMaxSeq].[MaxSeq]
                                            WHERE
                                                [psm].[PatientId] = @l_patient_id)
             UNION ALL
             SELECT
                MIN([start_ft]) AS [START_FT],
                MAX([end_ft]) AS [END_FT],
				MIN([start_dt]) AS [START_DT],
				MAX([end_dt]) AS [END_DT],
				CAST(NULL AS DATETIME) AS [START_UTC],
				CAST(NULL AS DATETIME) AS [END_UTC]
             FROM
                [dbo].[int_patient_channel] AS [ipc]
                INNER JOIN [dbo].[int_waveform] AS [iw]
                    ON [ipc].[patient_channel_id] = [iw].[patient_channel_id]
             WHERE
                [iw].[patient_id] = @l_patient_id
            ) AS [ComboWaveform];
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the minimum and maximum patient (filetime) times from waveform data.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetMinMaxPatientTimes';

