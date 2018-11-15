CREATE PROCEDURE [old].[uspGetPatientSavedEventCalipers]
    (
        @PatientID INT,
        @EventID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isc].[ChannelType],
            [isc].[CaliperType],
            [isc].[CaliperOrientation],
            [isc].[CaliperText],
            [isc].[Caliper_start_ms],
            [isc].[Caliper_end_ms],
            [isc].[CaliperTop],
            [isc].[CaliperBottom]
        FROM
            [Intesys].[SavedEventCalipers] AS [isc]
        WHERE
            [isc].[PatientID] = @PatientID
            AND [isc].[EventID] = @EventID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEventCalipers';

