CREATE PROCEDURE [Purger].[uspDeleteDataLoaderVital]
    (
        @ChunkSize            INT,
        @PurgeDateTime        DATETIME2(7),
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
                [vd]
                FROM
                    [old].[Vital] AS [vd] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [vd].[Timestamp] < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [sd]
                FROM
                    [old].[Status] AS [sd] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [sd].[SetID] IN (
                                        SELECT
                                            [sds].[StatusSetID]
                                        FROM
                                            [old].[StatusSet] AS [sds] WITH (ROWLOCK) -- Do not allow lock escalations.
                                        WHERE
                                            [sds].[Timestamp] < @PurgeDateTime
                                    );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [sds]
                FROM
                    [old].[StatusSet] AS [sds] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [sds].[Timestamp] < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @HL7MonitorRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge data loader vitals data.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteDataLoaderVital';

