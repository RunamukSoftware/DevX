CREATE PROCEDURE [old].[uspSaveEventMonitorEventLog]
    (
        @PatientID             INT,
        @EventID               INT,
        @TimeTagType AS        INT,
        @monitor_event_type AS INT,
        @start_ms AS           INT,
        @end_ms AS             INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventLog]
            (
                [PatientID],
                [EventID],
                [TimeTagType],
                [MonitorEventType],
                [start_ms],
                [end_ms]
            )
        VALUES
            (
                @PatientID, @EventID, @TimeTagType, @monitor_event_type, @start_ms, @end_ms
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventMonitorEventLog';

