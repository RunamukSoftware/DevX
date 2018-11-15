CREATE PROCEDURE [Purger].[uspDeleteResult]
    (
        @ChunkSize            INT,
        @PurgeDate            DATETIME2(7),
        @HL7MonitorRowsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ir]
                FROM
                    [Intesys].[Result] AS [ir]
                WHERE
                    [ir].[ObservationStartDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        DELETE
        [iol]
        FROM
            [Intesys].[OrderLine] AS [iol]
            INNER JOIN
                [Intesys].[Order] AS [io]
                    ON [iol].[OrderID] = [io].[OrderID]
        WHERE
            [io].[OrderDateTime] < @PurgeDate;

        SET @RC += @@ROWCOUNT;

        DELETE
        [iom]
        FROM
            [Intesys].[OrderMap]  AS [iom]
            INNER JOIN
                [Intesys].[Order] AS [io]
                    ON [iom].[OrderID] = [io].[OrderID]
        WHERE
            [io].[OrderDateTime] < @PurgeDate;

        SET @RC += @@ROWCOUNT;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [io]
                FROM
                    [Intesys].[Order] AS [io]
                WHERE
                    [io].[OrderDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @HL7MonitorRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge old int_results data.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteResult';

