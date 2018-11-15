CREATE PROCEDURE [Purger].[uspGetParameters]
    (
        @Name      NVARCHAR(30),
        @PurgeDate DATETIME2(7) OUTPUT,
        @ChunkSize INT          OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        --Default Chunk Size
        SET @ChunkSize = 200;

        SELECT
            @PurgeDate = DATEADD(HOUR, -CONVERT(   INT,
            (
                SELECT
                    [isp].[ParameterValue]
                FROM
                    [Intesys].[SystemParameter] AS [isp]
                WHERE
                    [isp].[Name] = @Name
            )                    ,                 111
                                               ), SYSUTCDATETIME()
                                );

        IF (
               (
                   SELECT
                       [isp].[ParameterValue]
                   FROM
                       [Intesys].[SystemParameter] AS [isp]
                   WHERE
                       [isp].[ActiveFlag] = 1
                       AND [isp].[Name] = N'ChunkSize'
               ) IS NOT NULL
           )
            SELECT
                @ChunkSize = CAST([isp].[ParameterValue] AS INT)
            FROM
                [Intesys].[SystemParameter] AS [isp]
            WHERE
                [isp].[ActiveFlag] = 1
                AND [isp].[Name] = N'ChunkSize';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspGetParameters';

