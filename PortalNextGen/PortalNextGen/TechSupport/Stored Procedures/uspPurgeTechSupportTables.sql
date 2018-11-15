CREATE PROCEDURE [TechSupport].[uspPurgeTechSupportTables] (@Days AS INT = 15)
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @ExpirationDate AS DATETIME2(7);

        IF (@Days IS NULL)
            SET @Days = 15;

        SET @ExpirationDate = DATEADD(DAY, - (@Days), SYSUTCDATETIME());

        DELETE
        [gwir]
        FROM
            [TechSupport].[WaveformIndexRate] AS [gwir]
        WHERE
            [gwir].[PeriodStartDateTime] < @ExpirationDate;

        DELETE
        [gir]
        FROM
            [TechSupport].[InputRate] AS [gir]
        WHERE
            [gir].[PeriodStart] < @ExpirationDate;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'PROCEDURE', @level1name = N'uspPurgeTechSupportTables';

