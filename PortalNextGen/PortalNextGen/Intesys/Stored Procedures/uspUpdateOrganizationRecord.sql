CREATE PROCEDURE [Intesys].[uspUpdateOrganizationRecord]
    (
        @AutoCollectInterval INT,
        @OutboundInterval    INT,
        @PrinterName         VARCHAR(255),
        @AlarmPrinterName    VARCHAR(255),
        @OrganizationID      INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Organization]
        SET
            [AutoCollectInterval] = @AutoCollectInterval,
            [OutboundInterval] = @OutboundInterval,
            [PrinterName] = @PrinterName,
            [AlarmPrinterName] = @AlarmPrinterName
        WHERE
            [OrganizationID] = @OrganizationID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'PROCEDURE', @level1name = N'uspUpdateOrganizationRecord';

