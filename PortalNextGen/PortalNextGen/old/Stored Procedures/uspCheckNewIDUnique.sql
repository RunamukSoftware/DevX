CREATE PROCEDURE [old].[uspCheckNewIDUnique] (@Value INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            COUNT(*) AS [TotalCount]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[CodeID] = @Value;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspCheckNewIDUnique';

