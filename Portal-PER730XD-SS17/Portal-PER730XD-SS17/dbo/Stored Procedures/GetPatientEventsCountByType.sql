CREATE PROCEDURE [dbo].[GetPatientEventsCountByType]
    (
     @user_id UNIQUEIDENTIFIER,
     @patient_id UNIQUEIDENTIFIER,
     @type INT
    )
AS
BEGIN
    SELECT
        [AE].[num_events] AS [EVENT_COUNT]
    FROM
        [dbo].[AnalysisEvents] AS [AE]
    WHERE
        [AE].[user_id] = @user_id
        AND [AE].[patient_id] = @patient_id
        AND [AE].[type] = @type; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientEventsCountByType';

