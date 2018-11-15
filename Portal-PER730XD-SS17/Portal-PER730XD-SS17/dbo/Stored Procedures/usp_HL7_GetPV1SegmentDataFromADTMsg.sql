CREATE PROCEDURE [dbo].[usp_HL7_GetPV1SegmentDataFromADTMsg]
    (
     @patient_id2 UNIQUEIDENTIFIER
    )
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (1)
        [enc].[patient_type_cid] AS [PatientType],
        [enc].[med_svc_cid] AS [HospService],
        [enc].[patient_class_cid] AS [PatientClass],
        [enc].[ambul_status_cid] AS [AmbulatorySts],
        [enc].[vip_sw] AS [VipIndic],
        [enc].[discharge_dispo_cid] AS [DischDisposition],
        [enc].[admit_dt] AS [AdmitDate],
        [enc].[discharge_dt] AS [DischargeDt],
        [enc].[status_cd],
        [int_encounter_map].[encounter_xid] AS [VisitNumber]
    FROM
        [dbo].[int_encounter] AS [enc]
        INNER JOIN [dbo].[int_encounter_map] ON [enc].[encounter_id] = [int_encounter_map].[encounter_id]
    WHERE
        [enc].[patient_id] = @patient_id2
        AND [enc].[status_cd] = N'C'
        AND [enc].[encounter_id] NOT IN (SELECT
                                        [encounter_id]
                                     FROM
                                        [dbo].[int_patient_monitor]
                                     WHERE
                                        [active_sw] = 1)
    ORDER BY
        [AdmitDate] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient details by Account Number.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetPV1SegmentDataFromADTMsg';

