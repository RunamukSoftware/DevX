CREATE PROCEDURE [dbo].[DeleteTrendData]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID] -- TG - Should be UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE FROM
        [dbo].[TrendData]
    WHERE
        [user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteTrendData';

