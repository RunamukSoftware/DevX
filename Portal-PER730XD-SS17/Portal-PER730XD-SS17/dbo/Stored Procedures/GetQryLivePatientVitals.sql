CREATE PROCEDURE [dbo].[GetQryLivePatientVitals]
    (
     @patient_id AS UNIQUEIDENTIFIER
    )
AS
BEGIN
    -- Create the equivalent date time to (GETDATE( ) - 0.002)
    DECLARE @LowerTimeLimit DATETIME = DATEADD(MILLISECOND, -172800, GETDATE());

    SELECT DISTINCT
        [VL].[patient_id] AS [PATID],
        [VL].[monitor_id] AS [MONITORID],
        [VL].[collect_dt] AS [COLLECTDATE],
        [VL].[vital_value] AS [VITALS],
        [VL].[vital_time] AS [VITALSTIME],
        [MRNMAP].[organization_id] AS [ORGID],
        [MRNMAP].[mrn_xid] AS [MRN]
    FROM
        [dbo].[int_vital_live_temp] AS [VL]
        INNER JOIN [dbo].[int_mrn_map] AS [MRNMAP] ON [VL].[patient_id] = [MRNMAP].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [PM] ON [VL].[patient_id] = [PM].[patient_id]
                                                          AND [VL].[monitor_id] = [PM].[monitor_id]
    WHERE
        (@patient_id = CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)
        OR [VL].[patient_id] = @patient_id
        )
        AND [merge_cd] = 'C'
        AND [VL].[createdDT] = (SELECT
                                    MAX([createdDT])
                                FROM
                                    [dbo].[int_vital_live_temp] AS [VL_SUBTAB]
                                WHERE
                                    [VL_SUBTAB].[monitor_id] = [VL].[monitor_id]
                                    AND [VL_SUBTAB].[patient_id] = [VL].[patient_id]
                                    AND [createdDT] > @LowerTimeLimit
                               );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get live patient vitals.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetQryLivePatientVitals';

