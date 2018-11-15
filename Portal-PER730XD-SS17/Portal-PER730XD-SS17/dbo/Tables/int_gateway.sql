CREATE TABLE [dbo].[int_gateway] (
    [gateway_id]           UNIQUEIDENTIFIER NOT NULL,
    [gateway_type]         CHAR (4)         NULL,
    [network_id]           NVARCHAR (30)    NULL,
    [hostname]             NVARCHAR (80)    NULL,
    [enable_sw]            TINYINT          NULL,
    [recv_app]             NVARCHAR (30)    NULL,
    [send_app]             NVARCHAR (30)    NULL,
    [reconnect_secs]       INT              NULL,
    [organization_id]      UNIQUEIDENTIFIER NULL,
    [send_sys_id]          UNIQUEIDENTIFIER NULL,
    [results_usid]         INT              NULL,
    [sleep_secs]           INT              NULL,
    [add_monitors_sw]      TINYINT          NULL,
    [add_patients_sw]      TINYINT          NULL,
    [add_results_sw]       TINYINT          NULL,
    [debug_level]          INT              NULL,
    [unit_org_id]          UNIQUEIDENTIFIER NULL,
    [patient_id_type]      CHAR (4)         NULL,
    [auto_assign_id_sw]    TINYINT          NULL,
    [new_mrn_format]       NVARCHAR (80)    NULL,
    [auto_chan_attach_sw]  TINYINT          NULL,
    [live_vitals_sw]       TINYINT          NULL,
    [live_waveform_size]   INT              NULL,
    [decnet_node]          INT              NULL,
    [node_name]            CHAR (5)         NULL,
    [nodes_excluded]       NVARCHAR (255)   NULL,
    [nodes_included]       NVARCHAR (255)   NULL,
    [timemaster_sw]        TINYINT          NULL,
    [waveform_size]        INT              NULL,
    [print_enabled_sw]     TINYINT          NULL,
    [auto_record_alarm_sw] TINYINT          NULL,
    [collect_12_lead_sw]   TINYINT          NULL,
    [print_auto_record_sw] TINYINT          NULL,
    [encryption_status]    BIT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_gateway_gateway_id]
    ON [dbo].[int_gateway]([gateway_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_gateway_network_id]
    ON [dbo].[int_gateway]([network_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The int_gateway table stores configuration information about all known "gateways". Gateways provide connectivity to monitors (SLMD, S5, Cosmos, etc). Each gateway is responsible for keeping the database current for the monitors it knows about. It is also responsible for updating monitors when patient changes are made to the database.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_gateway';

