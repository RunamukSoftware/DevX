CREATE PROCEDURE [dbo].[usp_UpdateGatewaySettings]
    (
     @network_id NVARCHAR(30),
     @enable_sw TINYINT,
     @recv_app NVARCHAR(30),
     @send_app NVARCHAR(30),
     @organization_id UNIQUEIDENTIFIER,
     @send_sys_id UNIQUEIDENTIFIER,
     @results_usid INT,
     @sleep_secs INT,
     @debug_level INT,
     @unit_org_id UNIQUEIDENTIFIER,
     @patient_id_type CHAR(4),
     @gateway_type CHAR(4),
     @auto_assign_id_sw TINYINT,
     @new_mrn_format NVARCHAR(80),
     @auto_chan_attach_sw TINYINT,
     @live_vitals_sw TINYINT,
     @live_waveform_size INT,
     @decnet_node INT,
     @node_name CHAR(5),
     @nodes_excluded NVARCHAR(255),
     @nodes_included NVARCHAR(255),
     @timemaster_sw TINYINT,
     @waveform_size INT,
     @print_enabled_sw TINYINT,
     @auto_record_alarm_sw TINYINT,
     @collect_12_lead_sw TINYINT,
     @print_auto_record_sw TINYINT,
     @encryption_status BIT,
     @gateway_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_gateway]
    SET
        [network_id] = @network_id,
        [hostname] = N'localhost',
        [enable_sw] = @enable_sw,
        [reconnect_secs] = 0,
        [recv_app] = @recv_app,
        [send_app] = @send_app,
        [organization_id] = @organization_id,
        [send_sys_id] = @send_sys_id,
        [results_usid] = @results_usid,
        [sleep_secs] = @sleep_secs,
        [add_monitors_sw] = 1,
        [debug_level] = @debug_level,
        [unit_org_id] = @unit_org_id,
        [patient_id_type] = @patient_id_type,
        [add_patients_sw] = 1,
        [gateway_type] = @gateway_type,
        [auto_assign_id_sw] = @auto_assign_id_sw,
        [new_mrn_format] = @new_mrn_format,
        [auto_chan_attach_sw] = @auto_chan_attach_sw,
        [live_vitals_sw] = @live_vitals_sw,
        [live_waveform_size] = @live_waveform_size,
        [decnet_node] = @decnet_node,
        [node_name] = @node_name,
        [nodes_excluded] = @nodes_excluded,
        [nodes_included] = @nodes_included,
        [timemaster_sw] = @timemaster_sw,
        [waveform_size] = @waveform_size,
        [print_enabled_sw] = @print_enabled_sw,
        [auto_record_alarm_sw] = @auto_record_alarm_sw,
        [collect_12_lead_sw] = @collect_12_lead_sw,
        [print_auto_record_sw] = @print_auto_record_sw,
        [encryption_status] = @encryption_status
    WHERE
        [gateway_id] = @gateway_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateGatewaySettings';

