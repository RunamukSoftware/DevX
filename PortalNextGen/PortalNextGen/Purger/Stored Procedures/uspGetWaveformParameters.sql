CREATE PROCEDURE [Purger].[uspGetWaveformParameters]
    (
        @PurgeDate DATETIME2(7) OUTPUT,
        @ChunkSize INT          OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @NumberOfHours INT;

        SELECT TOP (1)
            @NumberOfHours = CAST([is].[Setting] AS INT)
        FROM
            [Intesys].[SystemGeneration] AS [is]
        WHERE
            [is].[ProductCode] = 'fulldiscl'
            AND [is].[FeatureCode] = 'NUMBER_OF_HOURS';

        IF (@NumberOfHours IS NULL)
            BEGIN
                SELECT
                    @PurgeDate = DATEADD(HOUR, -24, SYSUTCDATETIME()); --Default is 24 hrs
            END;
        ELSE
            BEGIN
                SELECT
                    @PurgeDate = DATEADD(HOUR, -@NumberOfHours, SYSUTCDATETIME());
            END;

        SET @ChunkSize = 1500; --Default Chunk size is 1500

        IF (
               (
                   SELECT TOP (1)
                       [isp].[ParameterValue]
                   FROM
                       [Intesys].[SystemParameter] AS [isp]
                   WHERE
                       [isp].[ActiveFlag] = 1
                       AND [isp].[Name] = N'ChunkSize'
               ) IS NOT NULL
           )
            SELECT TOP (1)
                @ChunkSize = CAST([isp].[ParameterValue] AS INT)
            FROM
                [Intesys].[SystemParameter] AS [isp]
            WHERE
                [isp].[ActiveFlag] = 1
                AND [isp].[Name] = N'ChunkSize';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspGetWaveformParameters';

