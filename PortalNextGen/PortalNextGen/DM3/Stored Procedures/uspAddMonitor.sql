CREATE PROCEDURE [DM3].[uspAddMonitor]
    (
        @MonitorID          INT,
        @UnitOrganizationID INT          = NULL,
        @NetworkID          NVARCHAR(15),
        @NodeID             NVARCHAR(15),
        @MonitorTypeCode    VARCHAR(5)   = NULL,
        @MonitorName        NVARCHAR(30),
        @Subnet             NVARCHAR(50) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Monitor]
            (
                [MonitorID],
                [UnitOrganizationID],
                [NetworkID],
                [NodeID],
                [BedID],
                [BedCode],
                [Room],
                [MonitorTypeCode],
                [MonitorName],
                [Subnet]
            )
        VALUES
            (
                @MonitorID,
                @UnitOrganizationID,
                @NetworkID,
                @NodeID,
                N'0',
                N'0',
                N'0',
                @MonitorTypeCode,
                @MonitorName,
                @Subnet
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddMonitor';

