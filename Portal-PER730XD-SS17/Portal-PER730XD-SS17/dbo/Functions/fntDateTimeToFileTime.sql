CREATE FUNCTION [dbo].[fntDateTimeToFileTime] (@DateTime AS DATETIME)
RETURNS TABLE
    WITH SCHEMABINDING
RETURN
    SELECT
        CASE WHEN @DateTime IS NULL THEN NULL
             ELSE (CAST(11644473600000 AS BIGINT) + DATEDIFF(ss, CAST('1970-01-01 00:00:00' AS DATETIME), @DateTime)
                   * CAST(1000 AS BIGINT) + DATEPART(Ms, @DateTime)) * CAST(10000 AS BIGINT)
        END AS [FileTime];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert UTC datetime format into local datetime format.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fntDateTimeToFileTime';

