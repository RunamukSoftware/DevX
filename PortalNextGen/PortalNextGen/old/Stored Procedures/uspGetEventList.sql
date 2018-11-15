CREATE PROCEDURE [old].[uspGetEventList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[Code],
            [imc].[ShortDescription]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[CategoryCode] = 'SLOG';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEventList';

