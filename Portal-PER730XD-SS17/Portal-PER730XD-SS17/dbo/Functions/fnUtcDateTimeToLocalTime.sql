CREATE FUNCTION [dbo].[fnUtcDateTimeToLocalTime] (@DateTime AS DATETIME)
RETURNS DATETIME
    WITH SCHEMABINDING
AS
BEGIN  
    RETURN 
        CASE
            WHEN @DateTime IS NULL THEN NULL
            ELSE DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), GETDATE()), @DateTime)
        END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Convert the UTC datetime to the local datetime.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fnUtcDateTimeToLocalTime';

