CREATE PROCEDURE [dbo].[usp_DL_ETR_UpdateGatewaySettings]
    (
     @gateway_type NVARCHAR(10),
     @farm_name NVARCHAR(5),
     @network NVARCHAR(30),
     @et_do_not_store_waveforms TINYINT,
     @include_trans_chs NVARCHAR(256), -- TG - should be NVARCHAR(255)
     @exclude_trans_chs NVARCHAR(256), -- TG - should be NVARCHAR(255)
     @et_print_alarms TINYINT,
     @gateway_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_DataLoader_ETR_Temp_Settings]
    SET
        [gateway_type] = @gateway_type,
        [farm_name] = @farm_name,
        [network] = @network,
        [et_do_not_store_waveforms] = @et_do_not_store_waveforms,
        [include_trans_chs] = CAST(@include_trans_chs AS NVARCHAR(255)),
        [exclude_trans_chs] = CAST(@exclude_trans_chs AS NVARCHAR(255)),
        [et_print_alarms] = @et_print_alarms
    WHERE
        [gateway_id] = @gateway_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DL_ETR_UpdateGatewaySettings';

