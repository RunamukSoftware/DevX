CREATE PROCEDURE [dbo].[GetPatientSavedEventVitalsNew]
    (
     @patient_id AS UNIQUEIDENTIFIER,
     @event_id AS UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [result_dt],
        [result_value],
        [gds_code]
    FROM
        [dbo].[int_savedevent_vitals]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEventVitalsNew';

