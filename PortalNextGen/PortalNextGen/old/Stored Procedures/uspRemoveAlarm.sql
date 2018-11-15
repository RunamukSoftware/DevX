CREATE PROCEDURE [old].[uspRemoveAlarm]
    (
        @AlarmID    INT,
        @RemoveFlag TINYINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Alarm]
        SET
            [Removed] = @RemoveFlag
        WHERE
            [AlarmID] = @AlarmID;

        UPDATE
            [old].[RemovedAlarm]
        SET
            [RemovedFlag] = @RemoveFlag
        WHERE
            [AlarmID] = @AlarmID;

        IF (@@ROWCOUNT = 0)
            INSERT INTO [old].[RemovedAlarm]
                (
                    [AlarmID],
                    [RemovedFlag]
                )
            VALUES
                (
                    @AlarmID, @RemoveFlag
                );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRemoveAlarm';

