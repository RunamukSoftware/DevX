CREATE FUNCTION [old].[ufnMarkIdAsDuplicate]
    (
        @id AS NVARCHAR(30)
    )
RETURNS NVARCHAR(30)
WITH RETURNS NULL ON NULL INPUT, SCHEMABINDING
AS
    BEGIN
        RETURN CASE
                   WHEN @id LIKE N'*_*%'
                       THEN CASE
                                WHEN LEFT(@id, 3) = N'***'
                                    THEN N'*1*' + SUBSTRING(@id, 4, 12)
                                WHEN SUBSTRING(@id, 2, 1) LIKE N'[0-8]'
                                    THEN N'*' + CAST(CAST(SUBSTRING(@id, 2, 1) AS INT) + 1 AS VARCHAR) + N'*'
                                         + RIGHT(@id, 12)
                                ELSE
                                    N'***' + RIGHT(@id, 12)
                            END
                   ELSE
                       N'***' + RIGHT(@id, 12)
               END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mark ID as duplicate.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'FUNCTION', @level1name = N'ufnMarkIdAsDuplicate';

