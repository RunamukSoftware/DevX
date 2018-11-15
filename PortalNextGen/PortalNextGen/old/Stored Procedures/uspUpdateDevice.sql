CREATE PROCEDURE [old].[uspUpdateDevice]
    (
        @DeviceDescription VARCHAR(50),
        @Room              VARCHAR(12),
        @DeviceID          INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [old].[Device]
        SET
            [Description] = @DeviceDescription,
            [Room] = @Room
        WHERE
            [DeviceID] = @DeviceID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateDevice';

