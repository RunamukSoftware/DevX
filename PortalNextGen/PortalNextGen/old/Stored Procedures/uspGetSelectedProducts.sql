CREATE PROCEDURE [old].[uspGetSelectedProducts] (@ProductCode VARCHAR(25))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[OrganizationID],
            [io].[CategoryCode],
            [io].[ParentOrganizationID],
            [io].[OrganizationCode],
            [io].[OrganizationName],
            [io].[InDefaultSwitch],
            [io].[MonitorDisableSwitch],
            [io].[AutoCollectInterval],
            [io].[OutboundInterval],
            [io].[PrinterName],
            [io].[AlarmPrinterName]
        FROM
            [Intesys].[ProductAccess]    AS [ipa]
            INNER JOIN
                [Intesys].[Organization] AS [io]
                    ON [ipa].[OrganizationID] = [io].[OrganizationID]
        WHERE
            [ipa].[ProductCode] = @ProductCode
        ORDER BY
            [io].[OrganizationName];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSelectedProducts';

