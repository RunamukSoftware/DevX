CREATE PROCEDURE [old].[uspGetPatientEventsCountByType]
    (
        @UserID    INT,
        @PatientID INT,
        @Type      INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [AE].[NumberOfEvents] AS [EVENT_COUNT]
        FROM
            [old].[AnalysisEvent] AS [AE]
        WHERE
            [AE].[UserID] = @UserID
            AND [AE].[PatientID] = @PatientID
            AND [AE].[Type] = @Type;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientEventsCountByType';

