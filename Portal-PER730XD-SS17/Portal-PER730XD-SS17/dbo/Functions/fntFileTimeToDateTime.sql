CREATE FUNCTION [dbo].[fntFileTimeToDateTime] (@DateTime AS BIGINT)
RETURNS TABLE
    WITH SCHEMABINDING
RETURN
    SELECT
        CASE WHEN @DateTime IS NULL THEN NULL
             ELSE DATEADD(ms, ((@DateTime) / CAST(10000 AS BIGINT)) % 86400000,
                          DATEADD(DAY, @DateTime / CAST(864000000000 AS BIGINT) - 109207, 0))
        END AS [DateTime];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert filetime format into local datetime format.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fntFileTimeToDateTime';

