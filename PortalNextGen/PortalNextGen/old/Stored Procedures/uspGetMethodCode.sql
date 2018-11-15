CREATE PROCEDURE [old].[uspGetMethodCode]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [imc].[MethodCode]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[MethodCode] IS NOT NULL
        ORDER BY
            [imc].[MethodCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetMethodCode';

