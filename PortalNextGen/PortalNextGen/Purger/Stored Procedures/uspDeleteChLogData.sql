CREATE PROCEDURE [Purger].[uspDeleteChLogData]
    (
        @ChunkSize       INT,
        @PurgeDate       DATETIME2(7),
        @CHLogDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        --Purge data from logData too on 2/28/08
        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ld]
                FROM
                    [old].[Log] AS [ld]
                WHERE
                    [ld].[DateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @CHLogDataPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteChLogData';

