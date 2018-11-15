CREATE PROCEDURE [old].[uspGetAnalysisTime]
    (
        @UserID    INT,
        @PatientID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [at].[StartDateTime],
            [at].[EndDateTime],
            [at].[AnalysisType]
        FROM
            [old].[AnalysisTime] AS [at]
        WHERE
            [at].[UserID] = @UserID
            AND [at].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetAnalysisTime';

