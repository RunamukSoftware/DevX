CREATE FUNCTION [dbo].[fnZeroIfBigger]
    (
     @value AS INT,
     @maxValue AS INT
    )
RETURNS INT
    WITH SCHEMABINDING
AS
BEGIN
    RETURN 
        CASE
            WHEN @value > @maxValue THEN 0
            ELSE @value
        END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return 0 if value is greater than maxValue, otherwise return the value.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fnZeroIfBigger';

