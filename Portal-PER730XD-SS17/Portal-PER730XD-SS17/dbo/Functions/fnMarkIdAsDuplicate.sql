CREATE FUNCTION [dbo].[fnMarkIdAsDuplicate] (@id AS VARCHAR(15))
RETURNS VARCHAR(15)
    WITH RETURNS NULL ON NULL INPUT,
         SCHEMABINDING
AS
BEGIN
    RETURN CASE 
        WHEN @id LIKE '*_*%' THEN 
        CASE 
            WHEN LEFT(@id, 3) = '***' THEN '*1*' + SUBSTRING(@id, 4, 12)
            WHEN SUBSTRING(@id, 2, 1) LIKE '[0-8]' THEN '*' + CAST(CAST(SUBSTRING(@id, 2, 1) AS INT) + 1 AS VARCHAR)+ '*' + RIGHT(@id, 12)
            ELSE '***' + RIGHT(@id, 12) 
            END
        ELSE '***' + RIGHT(@id, 12) 
        END;                    
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mark ID as duplicate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fnMarkIdAsDuplicate';

