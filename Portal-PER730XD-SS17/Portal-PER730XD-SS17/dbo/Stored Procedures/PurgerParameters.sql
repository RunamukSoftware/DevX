CREATE PROCEDURE [dbo].[PurgerParameters]
    (
     @Name VARCHAR(MAX), -- TG - should be NVARCHAR(30)
     @PurgeDate DATETIME OUTPUT,
     @ChunkSize INT OUTPUT
    )
AS
BEGIN
    SET @ChunkSize = 200; --Default Chunk Size
    SELECT
        @PurgeDate = DATEADD(hh, -CONVERT(INT, (SELECT
                                                    [isp].[parm_value]
                                                FROM
                                                    [dbo].[int_system_parameter] AS [isp]
                                                WHERE
                                                    [isp].[name] = CAST(@Name AS NVARCHAR(30))
                                               ), 111), GETDATE());  

    IF ((SELECT
            [isp].[parm_value]
         FROM
            [dbo].[int_system_parameter] AS [isp]
         WHERE
            [isp].[active_flag] = 1
            AND [isp].[name] = N'ChunkSize'
        ) IS NOT NULL)
        SELECT
            @ChunkSize = CAST ([isp].[parm_value] AS INT)
        FROM
            [dbo].[int_system_parameter] AS [isp]
        WHERE
            [isp].[active_flag] = 1
            AND [isp].[name] = N'ChunkSize';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'PurgerParameters';

