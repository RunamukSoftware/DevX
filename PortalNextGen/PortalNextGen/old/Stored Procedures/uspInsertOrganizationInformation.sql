CREATE PROCEDURE [old].[uspInsertOrganizationInformation]
    (
        @OrganizationID       INT,
        @CategoryCode         CHAR(1)       = NULL,
        @ParentOrganizationID INT           = NULL,
        @OrganizationCode     NVARCHAR(180) = NULL,
        @OrganizationName     NVARCHAR(180) = NULL,
        @InDefaultSearch      BIT,
        @MonitorDisableSwitch BIT,
        @AutoCollectInterval  INT           = NULL,
        @OutboundInterval     INT           = NULL,
        @PrinterName          VARCHAR(255)  = NULL,
        @AlarmPrinterName     VARCHAR(255)  = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Organization]
            (
                [OrganizationID],
                [CategoryCode],
                [ParentOrganizationID],
                [OrganizationCode],
                [OrganizationName],
                [InDefaultSwitch],
                [MonitorDisableSwitch],
                [AutoCollectInterval],
                [OutboundInterval],
                [PrinterName],
                [AlarmPrinterName]
            )
        VALUES
            (
                @OrganizationID, @CategoryCode, @ParentOrganizationID, @OrganizationCode, @OrganizationName,
                @InDefaultSearch, @MonitorDisableSwitch, @AutoCollectInterval, @OutboundInterval, @PrinterName,
                @AlarmPrinterName
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the Organization Information.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertOrganizationInformation';

