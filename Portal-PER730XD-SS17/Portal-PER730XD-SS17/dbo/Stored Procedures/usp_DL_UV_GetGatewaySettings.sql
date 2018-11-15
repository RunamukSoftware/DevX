CREATE PROCEDURE [dbo].[usp_DL_UV_GetGatewaySettings]
    (
     @GatewayType NVARCHAR(10)
    )
AS
BEGIN
    SELECT
        [gateway_id],
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
    FROM
        [dbo].[int_DataLoader_UV_Temp_Settings]
    WHERE
        [gateway_type] = @GatewayType
    ORDER BY
        [network_name];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DL_UV_GetGatewaySettings';

