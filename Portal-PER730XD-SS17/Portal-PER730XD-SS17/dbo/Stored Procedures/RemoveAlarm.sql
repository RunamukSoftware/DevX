CREATE PROCEDURE [dbo].[RemoveAlarm]
    (
     @alarm_id UNIQUEIDENTIFIER,
     @remove_flag TINYINT
    )
AS
BEGIN
    UPDATE
        [dbo].[int_alarm]
    SET
        [removed] = @remove_flag
    WHERE
        [alarm_id] = @alarm_id;

    UPDATE
        [dbo].[RemovedAlarms]
    SET
        [Removed] = @remove_flag
    WHERE
        [AlarmId] = @alarm_id;

    IF @@ROWCOUNT = 0
        INSERT  INTO [dbo].[RemovedAlarms]([AlarmId], [Removed])
        VALUES
                (@alarm_id, @remove_flag);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'RemoveAlarm';

