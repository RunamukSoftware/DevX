CREATE PROCEDURE [dbo].[usp_InsertOrganizationInformation]
    (
     @organizationId UNIQUEIDENTIFIER,
     @categoryCd CHAR(1) = NULL,
     @parentOrganizationId UNIQUEIDENTIFIER = NULL,
     @organizationCd NVARCHAR(180) = NULL,
     @organizationNm NVARCHAR(180) = NULL,
     @inDefaultSearch TINYINT = NULL,
     @monitorDisableSw TINYINT = NULL,
     @autoCollectInterval INT = NULL,
     @outboundInterval INT = NULL,
     @printerName VARCHAR(255) = NULL,
     @alarmPrinterName VARCHAR(255) = NULL
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_organization]
            ([organization_id],
             [category_cd],
             [parent_organization_id],
             [organization_cd],
             [organization_nm],
             [in_default_search],
             [monitor_disable_sw],
             [auto_collect_interval],
             [outbound_interval],
             [printer_name],
             [alarm_printer_name]
            )
    VALUES
            (@organizationId,
             @categoryCd,
             @parentOrganizationId,
             @organizationCd,
             @organizationNm,
             @inDefaultSearch,
             @monitorDisableSw,
             @autoCollectInterval,
             @outboundInterval,
             @printerName,
             @alarmPrinterName
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the Organization Information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertOrganizationInformation';

