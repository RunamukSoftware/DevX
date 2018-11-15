CREATE PROCEDURE [HL7].[uspGetPV1SegmentDataFromADTMsg] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT TOP (1)
            [enc].[PatientTypeCodeID]          AS [PatientType],
            [enc].[MedicalServiceCodeID]       AS [HospService],
            [enc].[PatientClassCodeID]         AS [PatientClass],
            [enc].[AmbulatoryStatusCodeID]     AS [AmbulatorySts],
            [enc].[VipSwitch]                  AS [VipIndicator],
            [enc].[DischargeDispositionCodeID] AS [DischargeDisposition],
            [enc].[AdmitDateTime]              AS [AdmitDate],
            [enc].[DischargeDateTime]          AS [DischargeDateTime],
            [enc].[StatusCode],
            [iem].[EncounterXID]               AS [VisitNumber]
        FROM
            [Intesys].[Encounter]        AS [enc]
            INNER JOIN
                [Intesys].[EncounterMap] AS [iem]
                    ON [enc].[EncounterID] = [iem].[EncounterID]
        WHERE
            [enc].[PatientID] = @PatientID
            AND [enc].[StatusCode] = N'C'
            AND [enc].[EncounterID] NOT IN (
                                               SELECT
                                                   [ipm].[EncounterID]
                                               FROM
                                                   [Intesys].[PatientMonitor] AS [ipm]
                                               WHERE
                                                   [ipm].[ActiveSwitch] = 1
                                           )
        ORDER BY
            [AdmitDate] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient details by Account Number.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetPV1SegmentDataFromADTMsg';

