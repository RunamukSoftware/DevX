CREATE FUNCTION [dbo].[fntZeroIfBigger]
    (
     @value AS INT,
     @maxValue AS INT
    )
RETURNS TABLE
    WITH SCHEMABINDING
    AS
    RETURN
        SELECT
            CASE WHEN @value > @maxValue THEN 0
                 ELSE @value
            END AS [ReturnValue];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return 0 if value is greater than maxValue, otherwise return the value.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fntZeroIfBigger';

