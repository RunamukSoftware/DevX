CREATE PROCEDURE [dbo].[GetMinMaxPatientTimesFromVitals]
    (
     @patient_id [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @getAll BIT = 1
    )
AS
BEGIN
    IF (@getAll = 0)
    BEGIN   
        SELECT
            MIN([ir].[result_ft]) AS [START_FT],
            MAX([ir].[result_ft]) AS [END_FT],
			MIN([ir].[result_dt]) AS [START_DT],
			MAX([ir].[result_dt]) AS [END_DT],
			CAST(NULL AS DATETIME) AS [START_UTC],
			CAST(NULL AS DATETIME) AS [END_UTC]
        FROM
            [dbo].[int_result] AS [ir]
        WHERE
            [ir].[patient_id] = CAST(@patient_id AS UNIQUEIDENTIFIER);
    END;
    ELSE
    BEGIN
        SELECT
            MIN([ComboVitals].[start_ft]) AS [START_FT],
            MAX([ComboVitals].[end_ft]) AS [END_FT],
			MIN([ComboVitals].[start_dt]) AS [START_DT],
			MAX([ComboVitals].[end_dt]) AS [END_DT],
			MIN([ComboVitals].[start_utc]) AS [START_UTC],
			MAX([ComboVitals].[end_utc]) AS [END_UTC]
        FROM
            (SELECT
				CAST(NULL AS bigint) AS [START_FT],
				CAST(NULL AS bigint) AS [END_FT],
				CAST(NULL AS DATETIME) AS [START_DT],
				CAST(NULL AS DATETIME) AS [END_DT],
                MIN([vd].[TimestampUTC]) AS [START_UTC],
                MAX([vd].[TimestampUTC]) AS [END_UTC]
             FROM
                [dbo].[VitalsData] AS [vd]
             WHERE
                [TopicSessionId] IN (SELECT
                                        [vpts].[TopicSessionId]
                                     FROM
                                        [dbo].[v_PatientTopicSessions] AS [vpts]
                                     WHERE
                                        [vpts].[PatientId] = CAST(@patient_id AS UNIQUEIDENTIFIER))
             UNION ALL
             SELECT
                MIN([RowNumber].[result_ft]) AS [START_FT],
                MAX([RowNumber].[result_ft]) AS [END_FT],
				MIN([RowNumber].[result_dt]) AS [START_DT],
				MAX([RowNumber].[result_dt]) AS [END_DT],
				CAST(NULL AS DATETIME) AS [START_UTC],
				CAST(NULL AS DATETIME) AS [END_UTC]
             FROM
                [dbo].[int_result] AS [RowNumber]
             WHERE
                [RowNumber].[patient_id] = CAST(@patient_id AS UNIQUEIDENTIFIER)
            ) AS [ComboVitals];
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetMinMaxPatientTimesFromVitals';

