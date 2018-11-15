CREATE PROCEDURE [old].[uspGetGatewayDetailsByCategoryCode]
    (
        @CategoryCode         CHAR(1) = NULL,
        @ParentOrganizationID INT     = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@ParentOrganizationID IS NULL)
            BEGIN
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
                    [Intesys].[Organization] AS [io]
                WHERE
                    [io].[CategoryCode] = @CategoryCode
                ORDER BY
                    [io].[CategoryCode];
            END;
        ELSE
            BEGIN
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
                    [Intesys].[Organization] AS [io]
                WHERE
                    [io].[CategoryCode] = @CategoryCode
                    AND [io].[ParentOrganizationID] = @ParentOrganizationID
                ORDER BY
                    [io].[CategoryCode];
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetGatewayDetailsByCategoryCode';

