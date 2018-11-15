CREATE FUNCTION [dbo].[fnLocalDateTimeToUtcTime] (@DateTime AS DATETIME)
RETURNS DATETIME
    WITH SCHEMABINDING
BEGIN  
    RETURN
        CASE
            WHEN @DateTime IS NULL THEN NULL
            ELSE DATEADD(MINUTE, DATEDIFF(MINUTE, GETDATE(), GETUTCDATE()), @DateTime)
        END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert the local datetime to UTC datetime.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fnLocalDateTimeToUtcTime';

