CREATE PROCEDURE [Purger].[uspDeleteDataLoaderWaveform]
    (
        @ChunkSize          INT,
        @PurgeDateUTC       DATETIME2(7),
        @WaveformDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @RC   INT = 0,
            @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [wd]
                FROM
                    [old].[Waveform] AS [wd] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [wd].[StartDateTime] < @PurgeDateUTC;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @WaveformDataPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge DL waveform data.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteDataLoaderWaveform';

