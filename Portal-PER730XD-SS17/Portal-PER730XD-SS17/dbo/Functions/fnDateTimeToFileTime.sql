CREATE FUNCTION [dbo].[fnDateTimeToFileTime] (@DateTime AS DATETIME)
RETURNS BIGINT
    WITH SCHEMABINDING
BEGIN  
    RETURN
        CASE
            WHEN @DateTime IS NULL THEN NULL
            ELSE (CAST(11644473600000 AS BIGINT) + DATEDIFF(SECOND, CAST('1970-01-01 00:00:00' AS DATETIME), @DateTime) 
                * CAST(1000 AS BIGINT) + DATEPART(MILLISECOND, @DateTime)) * CAST(10000 AS BIGINT)
        END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert datetime to filetime format', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fnDateTimeToFileTime';

