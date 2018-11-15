CREATE PROCEDURE [dbo].[p_Purge_Release_Data]
AS
BEGIN
    TRUNCATE TABLE [dbo].[HL7_in_qhist];

    TRUNCATE TABLE [dbo].[HL7_in_queue];

    TRUNCATE TABLE [dbo].[HL7_msg_ack];

    TRUNCATE TABLE [dbo].[HL7_out_queue];

    TRUNCATE TABLE [dbo].[int_autoupdate_log];

    TRUNCATE TABLE [dbo].[int_broadcast_msg];

    TRUNCATE TABLE [dbo].[int_client_map];

    TRUNCATE TABLE [dbo].[int_loader_stats];

    TRUNCATE TABLE [dbo].[int_mon_request];

    TRUNCATE TABLE [dbo].[int_monitor];

    TRUNCATE TABLE [dbo].[int_patient_monitor];

    TRUNCATE TABLE [dbo].[int_msg_log];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Release_Data';

