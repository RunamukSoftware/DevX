CREATE FUNCTION [old].[ufnZeroIfBigger]
    (
        @Value AS        INT,
        @MaximumValue AS INT
    )
RETURNS INT
WITH SCHEMABINDING
AS
    BEGIN
        RETURN CASE
                   WHEN @Value > @MaximumValue
                       THEN 0
                   ELSE
                       @Value
               END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return 0 if value is greater than maxValue, otherwise return the value.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'FUNCTION', @level1name = N'ufnZeroIfBigger';

