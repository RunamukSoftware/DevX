CREATE PROCEDURE [old].[uspGetPatientEventTypes]
    (
        @UserID    INT,
        @PatientID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [AE].[Type]
        FROM
            [old].[AnalysisEvent] AS [AE]
        WHERE
            ([AE].[UserID] = @UserID)
            AND ([AE].[PatientID] = @PatientID);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientEventTypes';

