CREATE PROCEDURE [dbo].[usp_CEI_DL_GetLiveVitals]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [vlvd].[Name],
        [vlvd].[ResultValue],
        [vlvd].[GdsCode],
        [int_misc_code].[int_keystone_cd] AS [UOM],
        [int_misc_code].[short_dsc] AS [Short_Desc],
        [vlvd].[PatientId],
        [PATDATA].[MRN_ID] AS [ID1],
        [PATDATA].[ACCOUNT_ID] AS [ID2],
        [PATDATA].[UNIT_CODE] AS [organization_cd],
        [PATDATA].[patient_name],
        [PATDATA].[MONITOR_NAME],
        [PATDATA].[MONITOR_NAME] AS [NodeId]
    FROM
        [dbo].[v_LiveVitalsData] AS [vlvd]
        INNER JOIN (SELECT
                        [TopicInstanceId],
                        MAX([DateTimeStampUTC]) AS [MaxVitalTime]
                    FROM
                        [dbo].[v_LiveVitalsData]
                    GROUP BY
                        [TopicInstanceId]
                   ) AS [MaxLiveVital] ON [MaxLiveVital].[TopicInstanceId] = [vlvd].[TopicInstanceId]
                                          AND [MaxLiveVital].[MaxVitalTime] = [vlvd].[DateTimeStampUTC]
        LEFT OUTER JOIN [dbo].[v_PatientSessions] AS [PATDATA] ON [PATDATA].[patient_id] = [vlvd].[PatientId]
        INNER JOIN [dbo].[int_misc_code] ON [int_misc_code].[code] = [vlvd].[GdsCode]
    WHERE
        [vlvd].[GdsCode] IS NOT NULL
        AND [int_misc_code].[method_cd] = N'GDS';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_DL_GetLiveVitals';

