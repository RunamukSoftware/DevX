CREATE PROCEDURE [Purger].[uspDeleteDataLoaderEncounterData]
    (
        @ChunkSize           INT,
        @EncounterDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @PurgeDateTimeUTC DATETIME2(7) = DATEADD(DAY, -10, GETUTCDATE());
        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ds]
                FROM
                    [old].[DeviceSession] AS [ds] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [ds].[EndDateTime] IS NOT NULL
                    AND [ds].[EndDateTime] <= @PurgeDateTimeUTC;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [did]
                FROM
                    [old].[DeviceInformation] AS [did] WITH (ROWLOCK) -- Do not allow lock escalations.
                    LEFT OUTER JOIN
                        [old].[DeviceSession] AS [ds]
                            ON [did].[DeviceSessionID] = [ds].[DeviceSessionID]
                WHERE
                    [ds].[DeviceSessionID] IS NULL;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ts]
                FROM
                    [old].[TopicSession] AS [ts] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [ts].[EndDateTime] IS NOT NULL
                    AND [ts].[EndDateTime] <= @PurgeDateTimeUTC;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [pd]
                FROM
                    [old].[Patient] AS [pd] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [pd].[PatientSessionID] IN (
                                                   SELECT
                                                       [ps].[PatientSessionID]
                                                   FROM
                                                       [old].[PatientSession] AS [ps]
                                                   WHERE
                                                       [ps].[EndDateTime] IS NOT NULL
                                                       AND [ps].[EndDateTime] <= @PurgeDateTimeUTC
                                               )
                    AND [pd].[Timestamp] <= @PurgeDateTimeUTC;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ps]
                FROM
                    [old].[PatientSession] AS [ps] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [ps].[EndDateTime] IS NOT NULL
                    AND [ps].[EndDateTime] <= @PurgeDateTimeUTC
                    AND NOT EXISTS
                    (
                        SELECT
                            1
                        FROM
                            [old].[Patient] AS [pd]
                        WHERE
                            [pd].[PatientSessionID] = [ps].[PatientSessionID]
                    );


                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [psm]
                FROM
                    [old].[PatientSessionMap]  AS [psm] WITH (ROWLOCK) -- Do not allow lock escalations.
                    LEFT OUTER JOIN
                        [old].[PatientSession] AS [ps]
                            ON [psm].[PatientSessionID] = [ps].[PatientSessionID]
                WHERE
                    [ps].[PatientSessionID] IS NULL;


                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @EncounterDataPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge the data loader encounter data if the data is older than the specified purge date.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteDataLoaderEncounterData';

