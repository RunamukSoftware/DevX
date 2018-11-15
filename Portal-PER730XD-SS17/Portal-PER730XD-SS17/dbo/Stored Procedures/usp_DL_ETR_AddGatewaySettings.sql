CREATE PROCEDURE [dbo].[usp_DL_ETR_AddGatewaySettings]
    (
     @gateway_id UNIQUEIDENTIFIER,
     @gateway_type NVARCHAR(10),
     @farm_name NVARCHAR(5),
     @network NVARCHAR(30),
     @et_do_not_store_waveforms TINYINT,
     @include_trans_chs NVARCHAR(256), -- TG - should be NVARCHAR(255)
     @exclude_trans_chs NVARCHAR(256), -- TG - should be NVARCHAR(255)
     @et_print_alarms TINYINT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_DataLoader_ETR_Temp_Settings]
            ([gateway_id],
             [gateway_type],
             [farm_name],
             [network],
             [et_do_not_store_waveforms],
             [include_trans_chs],
             [exclude_trans_chs],
             [et_print_alarms]
            )
    VALUES
            (@gateway_id,
             @gateway_type,
             @farm_name,
             @network,
             @et_do_not_store_waveforms,
             CAST(@include_trans_chs AS NVARCHAR(255)),
             CAST(@exclude_trans_chs AS NVARCHAR(255)),
             @et_print_alarms
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DL_ETR_AddGatewaySettings';

