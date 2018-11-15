CREATE PROCEDURE [Purger].[uspDeleteHL7Success]
    (
        @ChunkSize            INT,
        @PurgeDate            DATETIME2(7),
        @HL7SuccessRowsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        /* HL7 SUCCESS */
        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [Intesys].[MessageLog]
                FROM
                    [HL7].[OutputQueue] AS [hoq]
                WHERE
                    [hoq].[MessageNumber] = [ExternalID]
                    AND [hoq].[MessageStatus] = 'R'
                    AND [hoq].[SentDateTime] < @PurgeDate;

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
                    AND [HL7OQ].[MessageStatus] = 'R'
                    AND [HL7OQ].[SentDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [iml]
                FROM
                    [Intesys].[MessageLog] AS [iml]
                WHERE
                    [iml].[ExternalID] IN (
                                              SELECT
                                                  CONVERT(VARCHAR(20), [him].[MessageNumber])
                                              FROM
                                                  [HL7].[InboundMessage] AS [him]
                                              WHERE
                                                  [him].[MessageStatus] = 'R'
                                                  AND [him].[MessageProcessedDate] < @PurgeDate
                                          );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [hoq]
                FROM
                    [HL7].[OutputQueue] AS [hoq]
                WHERE
                    [hoq].[MessageStatus] = 'R'
                    AND [hoq].[SentDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [hpl]
                FROM
                    [HL7].[PatientLink] AS [hpl]
                WHERE
                    [MessageNumber] IN (
                                       SELECT
                                           [him].[MessageNumber]
                                       FROM
                                           [HL7].[InboundMessage] AS [him]
                                       WHERE
                                           [him].[MessageStatus] = 'R'
                                           AND [him].[MessageProcessedDate] < @PurgeDate
                                   );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [him]
                FROM
                    [HL7].[InboundMessage] AS [him]
                WHERE
                    [him].[MessageStatus] = 'R'
                    AND [him].[MessageProcessedDate] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @HL7SuccessRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteHL7Success';

