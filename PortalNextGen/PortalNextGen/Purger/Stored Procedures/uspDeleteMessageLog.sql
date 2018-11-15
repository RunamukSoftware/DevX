CREATE PROCEDURE [Purger].[uspDeleteMessageLog]
    (
        @ChunkSize        INT,
        @PurgeDate        DATETIME2(7),
        @MessageLogPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [iml]
                FROM
                    [Intesys].[MessageLog] AS [iml]
                WHERE
                    [iml].[MessageDateTime] < @PurgeDate
                    AND [iml].[ExternalID] IS NULL;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @MessageLogPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteMessageLog';

