CREATE PROCEDURE [Purger].[uspDeleteHL7Error]
    (
        @ChunkSize          INT,
        @PurgeDate          DATETIME2(7),
        @HL7ErrorRowsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        /* HL7 ERROR */
        /* Fix for CR #2676 by Nancy on 1/16/08, Fail to purge due to SentDateTime is null */
        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [iml]
                FROM
                    [Intesys].[MessageLog]  AS [iml]
                    INNER JOIN
                        [HL7].[OutputQueue] AS [hoq]
                            ON [hoq].[MessageNumber] = [iml].[ExternalID]
                WHERE
                    [hoq].[MessageStatus] = 'E'
                    AND (
                            [hoq].[SentDateTime] < @PurgeDate
                            OR [hoq].[QueuedDateTime] < @PurgeDate
                        );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [HL7].[MessageAcknowledgement]
                FROM
                    [HL7].[OutputQueue] AS [HL7OQ]
                WHERE
                    [MessageControlID] = [HL7OQ].[MessageNumber]
                    AND [HL7OQ].[MessageStatus] = 'E'
                    AND (
                            [HL7OQ].[SentDateTime] < @PurgeDate
                            OR [HL7OQ].[QueuedDateTime] < @PurgeDate
                        );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [Intesys].[MessageLog]
                WHERE
                    [ExternalID] IN (
                                        SELECT
                                            CONVERT(VARCHAR(20), [him].[MessageNumber])
                                        FROM
                                            [HL7].[InboundMessage] AS [him]
                                        WHERE
                                            [him].[MessageStatus] = 'E'
                                            AND [him].[MessageQueuedDate] < @PurgeDate
                                    );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [HL7].[OutputQueue]
                WHERE
                    [MessageStatus] = 'E'
                    AND (
                            [SentDateTime] < @PurgeDate
                            OR [QueuedDateTime] < @PurgeDate
                        );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [HL7].[PatientLink]
                WHERE
                    [MessageNumber] IN (
                                       SELECT
                                           [him].[MessageNumber]
                                       FROM
                                           [HL7].[InboundMessage] AS [him]
                                       WHERE
                                           [him].[MessageStatus] = 'E'
                                           AND [him].[MessageQueuedDate] < @PurgeDate
                                   );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [HL7].[InboundMessage]
                WHERE
                    [MessageStatus] = 'E'
                    AND [MessageQueuedDate] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @HL7ErrorRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteHL7Error';

