CREATE PROCEDURE [dbo].[DeleteEventData]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID] -- TG - Should be UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [ae]
    FROM
        [dbo].[AnalysisEvents] AS [ae]
    WHERE
        [ae].[user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [ae].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteEventData';

