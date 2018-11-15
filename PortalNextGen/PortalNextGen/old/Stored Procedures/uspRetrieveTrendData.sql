CREATE PROCEDURE [old].[uspRetrieveTrendData]
    (
        @UserID    INT,
        @PatientID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [td].[UserID],
            [td].[PatientID],
            [td].[TotalCategories],
            [td].[StartDateTime],
            [td].[TotalPeriods],
            [td].[SamplesPerPeriod],
            [td].[TrendData]
        FROM
            [old].[Trend] AS [td]
        WHERE
            [td].[UserID] = @UserID
            AND [td].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrieveTrendData';

