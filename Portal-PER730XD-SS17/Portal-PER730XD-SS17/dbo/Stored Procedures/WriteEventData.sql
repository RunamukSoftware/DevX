CREATE PROCEDURE [dbo].[WriteEventData]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @Type INT,
     @NumEvents INT,
     @EventData IMAGE,
     @SampleRate SMALLINT
    )
AS
BEGIN
    INSERT  INTO [dbo].[AnalysisEvents]
            ([user_id],
             [patient_id],
             [type],
             [num_events],
             [sample_rate],
             [event_data]
            )
    VALUES
            (CAST(@UserID AS UNIQUEIDENTIFIER),
             CAST(@PatientId AS UNIQUEIDENTIFIER),
             @Type,
             @NumEvents,
             @SampleRate,
             @EventData
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'WriteEventData';

