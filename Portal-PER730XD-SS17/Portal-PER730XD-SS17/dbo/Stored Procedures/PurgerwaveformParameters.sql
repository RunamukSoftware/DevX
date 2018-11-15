CREATE PROCEDURE [dbo].[PurgerwaveformParameters]
    (
     @PurgeDate DATETIME OUTPUT,
     @ChunkSize INT OUTPUT
    )
AS
BEGIN
    DECLARE @NumberOfHours INT = CAST((SELECT
                                        [setting]
                                       FROM
                                        [dbo].[int_sysgen]
                                       WHERE
                                        [product_cd] = 'fulldiscl'
                                        AND [feature_cd] = 'NUMBER_OF_HOURS'
                                      ) AS INT);

    IF (@NumberOfHours IS NULL)
    BEGIN
        SELECT
            @PurgeDate = DATEADD(hh, -24, GETDATE());  --Default is 24 hrs
    END;
    ELSE
    BEGIN
        SELECT
            @PurgeDate = DATEADD(hh, -@NumberOfHours, GETDATE());  
    END;

    SET @ChunkSize = 200; --Default Chunk size is 200

    IF ((SELECT
            [parm_value]
         FROM
            [dbo].[int_system_parameter]
         WHERE
            [active_flag] = 1
            AND [name] = N'ChunkSize'
        ) IS NOT NULL)
        SELECT
            @ChunkSize = CAST([isp].[parm_value] AS INT)
        FROM
            [dbo].[int_system_parameter] AS [isp]
        WHERE
            [isp].[active_flag] = 1
            AND [isp].[name] = N'ChunkSize';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'PurgerwaveformParameters';

