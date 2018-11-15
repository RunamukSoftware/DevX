CREATE PROCEDURE [old].[uspGetUnitDetail] (@OrganizationID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[AutoCollectInterval],
            [io].[PrinterName],
            [io].[AlarmPrinterName],
            [io].[OutboundInterval]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[OrganizationID] = @OrganizationID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetUnitDetail';

