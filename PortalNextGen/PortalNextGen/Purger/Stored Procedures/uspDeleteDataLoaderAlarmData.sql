CREATE PROCEDURE [Purger].[uspDeleteDataLoaderAlarmData]
    (
        @ChunkSize        INT,
        @PurgeDateTime    DATETIME2(7),
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
                [gad]
                FROM
                    [old].[GeneralAlarm] AS [gad] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [gad].StartDateTime < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [lad]
                FROM
                    [old].[LimitAlarm] AS [lad] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [lad].StartDateTime < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [lcd]
                FROM
                    [old].[LimitChange] AS [lcd] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [lcd].[AcquiredDateTime] < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [asd]
                FROM
                    [old].[AlarmStatus] AS [asd] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [asd].[AcquiredDateTime] < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @AlarmsRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge DL alarm data.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteDataLoaderAlarmData';

