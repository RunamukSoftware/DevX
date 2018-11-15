CREATE PROCEDURE [dbo].[p_rel_CleanUp]
AS
BEGIN 
    TRUNCATE TABLE [dbo].[int_patient_monitor];

    TRUNCATE TABLE [dbo].[int_mon_request];

    TRUNCATE TABLE [dbo].[int_monitor];

    TRUNCATE TABLE [dbo].[HL7_in_qhist];

    TRUNCATE TABLE [dbo].[HL7_in_queue];

    TRUNCATE TABLE [dbo].[HL7_msg_ack];

    TRUNCATE TABLE [dbo].[HL7_out_queue];

    TRUNCATE TABLE [dbo].[int_audit_log];

    TRUNCATE TABLE [dbo].[int_autoupdate_log];

    TRUNCATE TABLE [dbo].[int_broadcast_msg];

    TRUNCATE TABLE [dbo].[int_client_map];

    TRUNCATE TABLE [dbo].[int_loader_stats];

    TRUNCATE TABLE [dbo].[int_msg_log];

    TRUNCATE TABLE [dbo].[int_outbound_queue];

    TRUNCATE TABLE [dbo].[mpi_decision_log];

    TRUNCATE TABLE [dbo].[mpi_decision_queue];

    TRUNCATE TABLE [dbo].[mpi_patient_link];

    TRUNCATE TABLE [dbo].[mpi_search_work];

    TRUNCATE TABLE [dbo].[int_environment];

    TRUNCATE TABLE [dbo].[int_pref_diff];

    TRUNCATE TABLE [dbo].[int_security_diff];

    TRUNCATE TABLE [dbo].[int_result_flag];

    TRUNCATE TABLE [dbo].[int_org_shift_sched];

    TRUNCATE TABLE [dbo].[int_translate_list];

    TRUNCATE TABLE [dbo].[int_user_group];

    TRUNCATE TABLE [dbo].[int_user_password];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_rel_CleanUp';

