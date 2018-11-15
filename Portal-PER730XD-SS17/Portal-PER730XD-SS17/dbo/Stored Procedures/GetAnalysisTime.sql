CREATE PROCEDURE [dbo].[GetAnalysisTime]
    (
     @UserID UNIQUEIDENTIFIER,
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [start_ft],
        [end_ft],
        [analysis_type]
    FROM
        [dbo].[AnalysisTime]
    WHERE
        [user_id] = @UserID
        AND [patient_id] = @PatientId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetAnalysisTime';

