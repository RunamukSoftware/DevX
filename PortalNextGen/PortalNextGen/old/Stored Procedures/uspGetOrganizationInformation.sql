CREATE PROCEDURE [old].[uspGetOrganizationInformation]
    (
        @OrganizationCode NVARCHAR(40) = NULL,
        @categoryCode       CHAR         = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (
               @OrganizationCode IS NOT NULL
               AND @categoryCode IS NOT NULL
           )
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
                    [io].[CategoryCode] = @categoryCode
                    AND [io].[OrganizationCode] = @OrganizationCode;
            END;
        ELSE IF (@categoryCode IS NOT NULL)
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
                         [io].[CategoryCode] = @categoryCode;
                 END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fetch the organization details based on the Organization code or Category Code.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetOrganizationInformation';

