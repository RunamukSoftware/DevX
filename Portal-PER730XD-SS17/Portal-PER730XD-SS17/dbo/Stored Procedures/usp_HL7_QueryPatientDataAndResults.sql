CREATE PROCEDURE [dbo].[usp_HL7_QueryPatientDataAndResults]
    (
     @QRYItem NVARCHAR(80),
     @type INT = -1,
     @StartDateTimeUTC DATETIME,
     @EndDateTimeUTC DATETIME
    )
AS
BEGIN
    DECLARE @monitor_id MonitorIdTable;
    DECLARE @patient_id UNIQUEIDENTIFIER = [dbo].[fn_HL7_GetPatientIdFromQueryItemType](@QRYItem, @type);
    DECLARE @StartTime DATETIME = [dbo].[fnUtcDateTimeToLocalTime](@StartDateTimeUTC); -- temp. Should be changed to use UTC time in the query
    DECLARE @EndTime DATETIME = [dbo].[fnUtcDateTimeToLocalTime](@EndDateTimeUTC); -- temp. Should be changed to use UTC time in the query

    -- Person and Patient data for PID
    EXEC [dbo].[usp_HL7_GetPersonAndPatientDataByPatientID] @patient_id;

    -- Common Order data for ORC
    EXEC [dbo].[usp_HL7_GetCommonOrderData];

    -- Request data for OBR
    EXEC [dbo].[usp_HL7_GetObservationRequestData];

    -- Observation results for OBX
    EXEC [dbo].[usp_HL7_GetObservationsByPatientId] @patient_id, @StartTime, @EndTime, @StartDateTimeUTC, @EndDateTimeUTC;

    INSERT  INTO @monitor_id
            ([Monitor_Id]
            )
    SELECT
        [PATMON].[monitor_id]
    FROM
        [dbo].[int_patient_monitor] AS [PATMON]
    WHERE
        [PATMON].[patient_id] = @patient_id
    UNION ALL
    SELECT DISTINCT
        [PATMON].[PATIENT_MONITOR_ID]
    FROM
        [dbo].[v_PatientSessions] AS [PATMON]
    WHERE
        [PATMON].[patient_id] = @patient_id;

    -- Patient visit/encounter information
    EXEC [dbo].[usp_HL7_GetPatientVisitInformation] @patient_id, @monitor_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the patient data and results for the given HL7 QRY02.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_QueryPatientDataAndResults';

