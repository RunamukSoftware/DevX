CREATE PROCEDURE [ClinicalAccess].[uspCheckEnhancedTelemetrySession] (@PatientID INT)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (1)
           [psm].[PatientSessionMapID]
    FROM [old].[PatientSessionMap] AS [psm]
        INNER JOIN (SELECT MAX([psm1].[PatientSessionMapID]) AS [MaxSeq]
                    FROM [old].[PatientSessionMap] AS [psm1]
                    GROUP BY [psm1].[PatientSessionID]) AS [PatientSessionMaxSeq]
            ON [psm].[PatientSessionMapID] = [PatientSessionMaxSeq].[MaxSeq]
    WHERE [psm].[PatientID] = @PatientID;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Check the latest Enhanced Telemetry (ET) sequence number for a patient.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspCheckEnhancedTelemetrySession';

