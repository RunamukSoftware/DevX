CREATE PROCEDURE [dbo].[p_Purge_All_Patient_Data]
AS
BEGIN
    TRUNCATE TABLE [dbo].[HL7_in_qhist];

    TRUNCATE TABLE [dbo].[HL7_in_queue];

    TRUNCATE TABLE [dbo].[HL7_msg_ack];

    TRUNCATE TABLE [dbo].[HL7_out_queue];

    TRUNCATE TABLE [dbo].[int_12lead_report_new];

    TRUNCATE TABLE [dbo].[int_12lead_report_edit];

    TRUNCATE TABLE [dbo].[int_account];

    TRUNCATE TABLE [dbo].[int_address];

    TRUNCATE TABLE [dbo].[int_alarm];

    TRUNCATE TABLE [dbo].[int_alarm_retrieved];

    TRUNCATE TABLE [dbo].[int_alarm_waveform];

    TRUNCATE TABLE [dbo].[int_allergy];

    TRUNCATE TABLE [dbo].[int_diagnosis];

    TRUNCATE TABLE [dbo].[int_diagnosis_drg];

    TRUNCATE TABLE [dbo].[int_diagnosis_hcp_int];

    TRUNCATE TABLE [dbo].[int_encounter];

    TRUNCATE TABLE [dbo].[int_encounter_map];

    TRUNCATE TABLE [dbo].[int_encounter_tfr_history];

    TRUNCATE TABLE [dbo].[int_encounter_to_hcp_int];

    TRUNCATE TABLE [dbo].[int_event_log];

    TRUNCATE TABLE [dbo].[int_external_organization];

    TRUNCATE TABLE [dbo].[int_guarantor];

    TRUNCATE TABLE [dbo].[int_hcp];

    TRUNCATE TABLE [dbo].[int_hcp_contact];

    TRUNCATE TABLE [dbo].[int_hcp_license];

    TRUNCATE TABLE [dbo].[int_hcp_map];

    TRUNCATE TABLE [dbo].[int_hcp_specialty];

    TRUNCATE TABLE [dbo].[int_insurance_plan];

    TRUNCATE TABLE [dbo].[int_insurance_policy];

    TRUNCATE TABLE [dbo].[int_mrn_map];

    TRUNCATE TABLE [dbo].[int_nok];

    TRUNCATE TABLE [dbo].[int_order];

    TRUNCATE TABLE [dbo].[int_order_line];

    TRUNCATE TABLE [dbo].[int_order_map];

    TRUNCATE TABLE [dbo].[int_outbound_queue];

    TRUNCATE TABLE [dbo].[int_param_timetag];

    TRUNCATE TABLE [dbo].[int_patient];

    TRUNCATE TABLE [dbo].[int_patient_channel];

    TRUNCATE TABLE [dbo].[int_patient_document];

    TRUNCATE TABLE [dbo].[int_patient_image];

    TRUNCATE TABLE [dbo].[int_patient_link];

    TRUNCATE TABLE [dbo].[int_patient_list];

    TRUNCATE TABLE [dbo].[int_patient_list_detail];

    TRUNCATE TABLE [dbo].[int_patient_list_link];

    TRUNCATE TABLE [dbo].[int_patient_monitor];

    TRUNCATE TABLE [dbo].[int_patient_procedure];

    TRUNCATE TABLE [dbo].[int_person];

    TRUNCATE TABLE [dbo].[int_person_name];

    TRUNCATE TABLE [dbo].[int_print_job];

    TRUNCATE TABLE [dbo].[int_print_job_waveform];

    TRUNCATE TABLE [dbo].[int_procedure];

    TRUNCATE TABLE [dbo].[int_procedure_hcp_int];

    TRUNCATE TABLE [dbo].[int_reference_range];

    TRUNCATE TABLE [dbo].[int_result];

    TRUNCATE TABLE [dbo].[int_specimen];

    TRUNCATE TABLE [dbo].[int_specimen_group];

    TRUNCATE TABLE [dbo].[int_telephone];

    TRUNCATE TABLE [dbo].[int_tech_map];

    TRUNCATE TABLE [dbo].[int_vital_live];

    TRUNCATE TABLE [dbo].[int_waveform];

    TRUNCATE TABLE [dbo].[int_waveform_live];

    TRUNCATE TABLE [dbo].[mpi_decision_log];

    TRUNCATE TABLE [dbo].[mpi_decision_field];

    TRUNCATE TABLE [dbo].[mpi_decision_queue];

    TRUNCATE TABLE [dbo].[mpi_patient_link];

    TRUNCATE TABLE [dbo].[mpi_search_results];

    TRUNCATE TABLE [dbo].[mpi_search_work];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_All_Patient_Data';

