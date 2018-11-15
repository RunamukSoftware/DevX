CREATE PROCEDURE [CEI].[uspPurgeLogData]
    (
        @ChunkSize    INT,
        @PurgeDate    DATETIME2(7),
        @CEILogPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [iel]
                FROM
                    [Intesys].[EventLog] AS [iel]
                WHERE
                    [iel].[EventDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @CEILogPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspPurgeLogData';

