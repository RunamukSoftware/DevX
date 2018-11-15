CREATE PROCEDURE [old].[uspSaveArrhythmiaEventTime]
    (
        @PatientID             INT,
        @EventID               INT,
        @TimeTagType           INT,
        @arrhythmia_event_type INT,
        @start_ms              INT,
        @end_ms                INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventLog]
            (
                [PatientID],
                [EventID],
                [TimeTagType],
                [ArrhythmiaEventType],
                [start_ms],
                [end_ms]
            )
        VALUES
            (
                @PatientID, @EventID, @TimeTagType, @arrhythmia_event_type, @start_ms, @end_ms
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveArrhythmiaEventTime';

