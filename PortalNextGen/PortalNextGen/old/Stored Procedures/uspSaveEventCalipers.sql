CREATE PROCEDURE [old].[uspSaveEventCalipers]
    @PatientID            INT,
    @EventID              INT,
    @channel_type         INT,
    @caliper_type         INT,
    @calipers_orientation NVARCHAR(50),
    @caliper_text         NVARCHAR(200),
    @caliper_start_ms     INT,
    @caliper_end_ms       INT,
    @caliper_top          INT,
    @caliper_bottom       INT
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventCalipers]
            (
                [PatientID],
                [EventID],
                [ChannelType],
                [CaliperType],
                [CaliperOrientation],
                [CaliperText],
                [Caliper_start_ms],
                [Caliper_end_ms],
                [CaliperTop],
                [CaliperBottom]
            )
        VALUES
            (
                @PatientID,
                @EventID,
                @channel_type,
                @caliper_type,
                @calipers_orientation,
                @caliper_text,
                @caliper_start_ms,
                @caliper_end_ms,
                @caliper_top,
                @caliper_bottom
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventCalipers';

