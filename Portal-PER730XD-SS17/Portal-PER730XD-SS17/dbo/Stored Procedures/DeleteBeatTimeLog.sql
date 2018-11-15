CREATE PROCEDURE [dbo].[DeleteBeatTimeLog]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @SampleRate SMALLINT
    )
AS
BEGIN
    DELETE [ibtl] FROM
        [dbo].[int_beat_time_log] AS [ibtl]
    WHERE
        [ibtl].[user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [ibtl].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [ibtl].[sample_rate] = @SampleRate;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteBeatTimeLog';

