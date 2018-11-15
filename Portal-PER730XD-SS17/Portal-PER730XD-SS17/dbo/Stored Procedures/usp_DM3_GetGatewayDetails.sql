CREATE PROCEDURE [dbo].[usp_DM3_GetGatewayDetails]
    (
     @NetworkID NVARCHAR(30)
    )
AS
BEGIN
    SELECT
        [gateway_id],
        [gateway_type],
        [network_id],
        [hostname],
        [enable_sw],
        [recv_app],
        [send_app],
        [reconnect_secs],
        [organization_id],
        [send_sys_id],
        [results_usid],
        [sleep_secs],
        [add_monitors_sw],
        [add_patients_sw],
        [add_results_sw],
        [debug_level],
        [unit_org_id],
        [patient_id_type],
        [auto_assign_id_sw],
        [new_mrn_format],
        [auto_chan_attach_sw],
        [live_vitals_sw],
        [live_waveform_size],
        [decnet_node],
        [node_name],
        [nodes_excluded],
        [nodes_included],
        [timemaster_sw],
        [waveform_size],
        [print_enabled_sw],
        [auto_record_alarm_sw],
        [collect_12_lead_sw],
        [print_auto_record_sw],
        [encryption_status]
    FROM
        [dbo].[int_gateway]
    WHERE
        [network_id] = @NetworkID;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetGatewayDetails';

