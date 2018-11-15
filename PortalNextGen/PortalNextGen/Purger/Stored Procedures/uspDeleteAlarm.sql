CREATE PROCEDURE [Purger].[uspDeleteAlarm]
    (
        @ChunkSize        INT,
        @PurgeDate        DATETIME2(7),
        @AlarmsRowsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [a]
                FROM
                    [Intesys].[Alarm] AS [a]
                WHERE
                    [a].StartDateTime < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @AlarmsRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteAlarm';

