CREATE PROCEDURE [dbo].[usp_DL_UV_AddGatewaySettings]
    (
     @gateway_id UNIQUEIDENTIFIER,
     @gateway_type NVARCHAR(20),
     @network_name NVARCHAR(30), -- TG - should be NVARCHAR(20)
     @network_id NVARCHAR(30),
     @node_name CHAR(5),
     @node_id CHAR(1024),
     @uv_organization_id UNIQUEIDENTIFIER,
     @uv_unit_id UNIQUEIDENTIFIER,
     @include_nodes NVARCHAR(255),
     @exclude_nodes NVARCHAR(255),
     @uv_do_not_store_waveforms TINYINT,
     @print_requests TINYINT,
     @make_time_master TINYINT,
     @auto_assign_id TINYINT,
     @new_mrn_format NVARCHAR(10),
     @uv_print_alarms TINYINT,
     @debug_level INT  
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_DataLoader_UV_Temp_Settings]
            ([gateway_id],
             [gateway_type],
             [network_name],
             [network_id],
             [node_name],
             [node_id],
             [uv_organization_id],
             [uv_unit_id],
             [include_nodes],
             [exclude_nodes],
             [uv_do_not_store_waveforms],
             [print_requests],
             [make_time_master],
             [auto_assign_id],
             [new_mrn_format],
             [uv_print_alarms],
             [debug_level]
            )
    VALUES
            (@gateway_id,
             @gateway_type,
             CAST(@network_name AS NVARCHAR(20)),
             @network_id,
             @node_name,
             @node_id,
             @uv_organization_id,
             @uv_unit_id,
             @include_nodes,
             @exclude_nodes,
             @uv_do_not_store_waveforms,
             @print_requests,
             @make_time_master,
             @auto_assign_id,
             @new_mrn_format,
             @uv_print_alarms,
             @debug_level
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DL_UV_AddGatewaySettings';

