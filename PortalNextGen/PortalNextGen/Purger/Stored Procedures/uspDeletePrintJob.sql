CREATE PROCEDURE [Purger].[uspDeletePrintJob]
    (
        @ChunkSize       INT,
        @PurgeDate       DATETIME2(7),
        @PrintJobsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ipjw]
                FROM
                    [Intesys].[PrintJobWaveform] AS [ipjw]
                WHERE
                    [ipjw].[RowDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ipj]
                FROM
                    [Intesys].[PrintJob] AS [ipj]
                WHERE
                    [ipj].[RowDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @PrintJobsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeletePrintJob';

