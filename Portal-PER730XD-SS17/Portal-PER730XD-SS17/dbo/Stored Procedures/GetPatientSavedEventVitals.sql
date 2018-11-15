CREATE PROCEDURE [dbo].[GetPatientSavedEventVitals]
    (
     @patient_id AS UNIQUEIDENTIFIER,
     @event_id AS UNIQUEIDENTIFIER,
     @gds_code AS NVARCHAR(80)
    )
AS
BEGIN
    SELECT
        [result_dt],
        [result_value]
    FROM
        [dbo].[int_savedevent_vitals]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id
        AND [gds_code] = @gds_code;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEventVitals';

