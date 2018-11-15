CREATE PROCEDURE [Purger].[uspDeleteChAuditLog]
    (
        @ChunkSize         INT,
        @PurgeDate         DATETIME2(7),
        @ChAuditDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        --Purge data from int_audit_log too on 2/28/08
        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ial]
                FROM
                    [Intesys].[AuditLog] AS [ial]
                WHERE
                    [ial].[AuditDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ald]
                FROM
                    [old].[AuditLog] AS [ald]
                WHERE
                    [ald].[AuditDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @ChAuditDataPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CH Audit Logs purge.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteChAuditLog';

