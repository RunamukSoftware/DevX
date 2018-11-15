CREATE PROCEDURE [old].[uspUpdateMonitor]
    (
        @MonitorDescription VARCHAR(50),
        @UnitOrganizationID INT,
        @Room               VARCHAR(12),
        @BedCode            NVARCHAR(20),
        @MonitorID          INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Monitor]
        SET
            [MonitorDescription] = @MonitorDescription,
            [UnitOrganizationID] = @UnitOrganizationID,
            [Room] = @Room,
            [BedCode] = @BedCode
        WHERE
            [MonitorID] = @MonitorID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateMonitor';

