CREATE PROCEDURE [Purger].[uspDeleteDataLoaderPrintJob]
    (
        @ChunkSize       INT,
        @PurgeDate       DATETIME2(7),
        @PrintJobsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;

        DELETE TOP (@ChunkSize)
        [old].[PrintBlob]
        WHERE
            [PrintRequestID] IN (
                                    SELECT
                                        [PrintRequestID]
                                    FROM
                                        [old].[PrintRequest]
                                    WHERE
                                        [Timestamp] < @PurgeDate
                                );

        SET @RC = @RC + @@ROWCOUNT;

        DELETE TOP (@ChunkSize)
        [old].[WaveformPrint]
        WHERE
            [PrintRequestID] IN (
                                    SELECT
                                        [PrintRequestID]
                                    FROM
                                        [old].[PrintRequest]
                                    WHERE
                                        [Timestamp] < @PurgeDate
                                );

        SET @RC = @RC + @@ROWCOUNT;

        DELETE TOP (@ChunkSize)
        [old].[PrintRequest]
        WHERE
            [Timestamp] < @PurgeDate;

        --TRUNCATE TABLE [old].[PrintJob] --don't have a clear idea 

        SET @RC = @RC + @@ROWCOUNT;

        SET @PrintJobsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteDataLoaderPrintJob';

