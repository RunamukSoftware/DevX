CREATE PROCEDURE [dbo].[SaveEventVitals]
    (
     @patient_id AS UNIQUEIDENTIFIER,
     @event_id AS UNIQUEIDENTIFIER,
     @gds_code AS NVARCHAR(80),
     @result_dt AS DATETIME,
     @result_value AS NVARCHAR(200)
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_savedevent_vitals]
            ([patient_id],
             [event_id],
             [gds_code],
             [result_dt],
             [result_value]
            )
    VALUES
            (@patient_id,
             @event_id,
             @gds_code,
             @result_dt,
             @result_value
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SaveEventVitals';

