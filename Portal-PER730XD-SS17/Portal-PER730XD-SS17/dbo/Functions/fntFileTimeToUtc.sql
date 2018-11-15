CREATE FUNCTION [dbo].[fntFileTimeToUtc] (@FtValue AS BIGINT)
RETURNS TABLE
    WITH SCHEMABINDING
RETURN
    SELECT
        CASE WHEN @FtValue IS NULL THEN NULL
             ELSE DATEADD(mi, DATEDIFF(mi, GETDATE(), GETUTCDATE()),
                          DATEADD(ms, ((@FtValue) / CAST(10000 AS BIGINT)) % 86400000,
                                  DATEADD(DAY, @FtValue / CAST(864000000000 AS BIGINT) - 109207, 0)))
        END AS [DateTimeUTC];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert filetime format into UTC datetime format.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fntFileTimeToUtc';

