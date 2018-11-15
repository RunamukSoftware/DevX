CREATE PROCEDURE [dbo].[GetPatientEventTypes]
    (
     @user_id UNIQUEIDENTIFIER,
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [AE].[type]
    FROM
        [dbo].[AnalysisEvents] AS [AE]
    WHERE
        ([AE].[user_id] = @user_id)
        AND ([AE].[patient_id] = @patient_id);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientEventTypes';

