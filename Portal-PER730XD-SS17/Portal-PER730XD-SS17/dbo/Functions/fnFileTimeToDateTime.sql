CREATE FUNCTION [dbo].[fnFileTimeToDateTime] (@DateTime AS BIGINT)
RETURNS DATETIME
    WITH SCHEMABINDING
AS
BEGIN  
    RETURN
        CASE
            WHEN @DateTime IS NULL THEN NULL
            ELSE DATEADD(MILLISECOND, ((@DateTime) / CAST(10000 AS BIGINT)) % 86400000, DATEADD(DAY, @DateTime / CAST(864000000000 AS BIGINT) - 109207, 0))
        END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert filetime to local datetime format', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fnFileTimeToDateTime';

