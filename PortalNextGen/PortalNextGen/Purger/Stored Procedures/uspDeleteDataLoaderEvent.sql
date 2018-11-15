CREATE PROCEDURE [Purger].[uspDeleteDataLoaderEvent]
    (
        @ChunkSize            INT,
        @PurgeDate            DATETIME2(7),
        @EventsDataRowsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ed]
                FROM
                    [old].[Event] AS [ed] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [ed].[Timestamp] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @EventsDataRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Remove rows from the EventsData table that are older than the purge date parameter.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteDataLoaderEvent';

