CREATE FUNCTION [dbo].[fntUtcDateTimeToLocalTime] (@DateTime AS DATETIME)
RETURNS TABLE
    WITH SCHEMABINDING
RETURN
    SELECT
        CASE WHEN @DateTime IS NULL THEN NULL
             ELSE DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), @DateTime)
        END AS [LocalDateTime];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert UTC datetime format into local datetime format.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fntUtcDateTimeToLocalTime';

