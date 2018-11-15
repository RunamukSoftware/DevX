CREATE PROCEDURE [old].[uspQueryPatientDataAndResults]
    (
        @QRYItem       NVARCHAR(80),
        @Type          INT         = -1,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @MonitorID [utpMonitorIDTable];
        DECLARE @PatientID INT = [old].[ufnHL7GetPatientIDFromQueryItemType](@QRYItem, @Type);

        -- Person and Patient data for PID
        EXEC [HL7].[uspGetPersonAndPatientDataByPatientID]
            @PatientID = @PatientID;

        -- Common Order data for ORC
        EXEC [HL7].[uspGetCommonOrderData];

        -- Request data for OBR
        EXEC [HL7].[uspGetObservationRequestData];

        -- Observation results for OBX
        EXEC [HL7].[uspHL7GetObservationsByPatientID]
            @PatientID = @PatientID,
            @StartDateTime = @StartDateTime,
            @EndDateTime = @EndDateTime;

        INSERT INTO @MonitorID
            (
                [MonitorID]
            )
                    SELECT
                        [PATMON].[MonitorID]
                    FROM
                        [Intesys].[PatientMonitor] AS [PATMON]
                    WHERE
                        [PATMON].[PatientID] = @PatientID
                    UNION ALL
                    SELECT DISTINCT
                        [PATMON].[PatientMonitorID]
                    FROM
                        [old].[vwPatientSessions] AS [PATMON]
                    WHERE
                        [PATMON].[PatientID] = @PatientID;

        -- Patient visit/encounter information
        EXEC [HL7].[uspGetPatientVisitInformation]
            @PatientID = @PatientID,
            @MonitorID = @MonitorID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the patient data and results for the given HL7 QRY02.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspQueryPatientDataAndResults';

