CREATE PROCEDURE [dbo].[usp_GetGateWaySettingsByDeviceType]
    (
     @GatewayType NVARCHAR(10)
    )
AS
BEGIN
    SELECT
        [int_gateway].[gateway_id],
        [int_gateway].[gateway_type],
        [int_gateway].[network_id],
        [int_gateway].[hostname],
        [int_gateway].[enable_sw],
        [int_gateway].[recv_app],
        [int_gateway].[send_app],
        [int_gateway].[reconnect_secs],
        [int_gateway].[organization_id],
        [int_gateway].[send_sys_id],
        [int_gateway].[results_usid],
        [int_gateway].[sleep_secs],
        [int_gateway].[add_monitors_sw],
        [int_gateway].[add_patients_sw],
        [int_gateway].[add_results_sw],
        [int_gateway].[debug_level],
        [int_gateway].[unit_org_id],
        [int_gateway].[patient_id_type],
        [int_gateway].[auto_assign_id_sw],
        [int_gateway].[new_mrn_format],
        [int_gateway].[auto_chan_attach_sw],
        [int_gateway].[live_vitals_sw],
        [int_gateway].[live_waveform_size],
        [int_gateway].[decnet_node],
        [int_gateway].[node_name],
        [int_gateway].[nodes_excluded],
        [int_gateway].[nodes_included],
        [int_gateway].[timemaster_sw],
        [int_gateway].[waveform_size],
        [int_gateway].[print_enabled_sw],
        [int_gateway].[auto_record_alarm_sw],
        [int_gateway].[collect_12_lead_sw],
        [int_gateway].[print_auto_record_sw],
        [int_gateway].[encryption_status]
    FROM
        [dbo].[int_gateway]
    WHERE
        [gateway_type] = @GatewayType
    ORDER BY
        [network_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetGateWaySettingsByDeviceType';

