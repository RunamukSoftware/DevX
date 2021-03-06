use [portal]
go

DROP INDEX [idxc_GeneralAlarmsData1] ON [dbo].[GeneralAlarmsData]
go

CREATE CLUSTERED INDEX [_dta_index_GeneralAlarmsData_c_5_1991678143__K1_9085] ON [dbo].[GeneralAlarmsData]
(
	[AlarmId] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1991678143_12_3_10_6] ON [dbo].[GeneralAlarmsData]([IDEnumValue], [StartDateTime], [TopicSessionId], [PriorityWeightValue])
go

CREATE STATISTICS [_dta_stat_1991678143_1_12_3_10_6] ON [dbo].[GeneralAlarmsData]([AlarmId], [IDEnumValue], [StartDateTime], [TopicSessionId], [PriorityWeightValue])
go

DROP INDEX [idxc_LimitAlarmsData1] ON [dbo].[LimitAlarmsData]
go

CREATE CLUSTERED INDEX [_dta_index_LimitAlarmsData_c_5_2055678371__K1_9085] ON [dbo].[LimitAlarmsData]
(
	[AlarmId] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

DROP INDEX [idx_VitalsData_1] ON [dbo].[VitalsData]
go

DROP INDEX [idx_VitalsData_3] ON [dbo].[VitalsData]
go

DROP INDEX [idx_VitalsData_2] ON [dbo].[VitalsData]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_VitalsData_5_212195806__K5_K7_K6_K3_K4_1] ON [dbo].[VitalsData]
(
	[TopicSessionId] ASC,
	[TimestampUTC] ASC,
	[FeedTypeId] ASC,
	[Name] ASC,
	[Value] ASC
)
INCLUDE ( 	[ID]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

DROP INDEX [index_int_result_gds_patient_result_ft] ON [dbo].[int_result]
go

DROP INDEX [rslt_ndx4] ON [dbo].[int_result]
go

DROP INDEX [index_int_result_patient_ft] ON [dbo].[int_result]
go

DROP INDEX [rslt_ndx2] ON [dbo].[int_result]
go

DROP INDEX [rslt_ndx3] ON [dbo].[int_result]
go

DROP INDEX [int_result_sequence] ON [dbo].[int_result]
go

DROP INDEX [idx_Waveformdata1] ON [dbo].[WaveformData]
go

DROP INDEX [_dta_index_MetaData_5_804197915__K2_K5_K6_K7_K9_K1_K8_K10_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K5_K1_K10_K6_K2_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K5_K2_K10_K6_K9_K1_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_804197915__K2_K5_K10_K1_K6_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K10_K2_K5_K1_K9_K6_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K10_K1_K2_K5_K6_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K1_K2_K10_K5_K6_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K2_K5_K1_K10_K9_K6_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K5_K2_K10_K1_K6_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K2_K5_K9_K1_K6_K10_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_804197915__K6_K2_K5_K1_K10_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_804197915__K7_K5_K1_K6_K8] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K1_K2_K5_K10_K8_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_52195236__K2_K5_K1_K8_K10_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_52195236__K5_K1_K10_K8_K2_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K2_K5_K10_K8_K1_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K2_K5_K10_K8_K1_K9_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K6_K2_K5_K1_K10] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_14_1239675464__K2_K1_K10_K5_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_52195236__K2_K5_3_8_10] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_9_1591676718__K5_K9_K10_1_9987] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K9_K5_K1_K10] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_804197915__K9_K5_K1_K10_K2] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K10_K9_K5_K1] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K5_K9_K10_K1_K2] ON [dbo].[MetaData]
go

DROP INDEX [IX_MetaData] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_804197915__K2_K5_K6_3] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_9_1415676091__K2_K5_K10] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_1959678029__K5_K2_3] ON [dbo].[MetaData]
go

DROP INDEX [IX_MetaDataEntityName] ON [dbo].[MetaData]
go

DROP INDEX [IX_MetaDataEntityMemberName] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_MetaData_5_52195236__K5_K2] ON [dbo].[MetaData]
go

DROP INDEX [IX_MetaDataName] ON [dbo].[MetaData]
go

DROP INDEX [IX_MetaDataMetaDataId] ON [dbo].[MetaData]
go

DROP INDEX [IX_MetaDataIsLookUp] ON [dbo].[MetaData]
go

DROP INDEX [_dta_index_ResourceStrings_7_1028198713__K4_K1_2] ON [dbo].[ResourceStrings]
go

DROP INDEX [IX_DeviceInfoData_4_3] ON [dbo].[DeviceInfoData]
go

DROP INDEX [IX_DeviceInfoData_8_7] ON [dbo].[DeviceInfoData]
go

DROP INDEX [IX_DeviceInfoData_2_1] ON [dbo].[DeviceInfoData]
go

DROP INDEX [_dta_index_int_misc_code_5_1765581328__K1_K9_K6_K8] ON [dbo].[int_misc_code]
go

DROP INDEX [_dta_index_int_misc_code_5_1765581328__K6_K1_K9_K8] ON [dbo].[int_misc_code]
go

DROP INDEX [misc_code_ndx2] ON [dbo].[int_misc_code]
go

DROP INDEX [_dta_index_int_misc_code_5_1765581328__K1_K6] ON [dbo].[int_misc_code]
go

DROP INDEX [misc_code_ndx3] ON [dbo].[int_misc_code]
go

DROP INDEX [_dta_index_Enums_GroupValueName] ON [dbo].[Enums]
go

DROP INDEX [index_param_timetag] ON [dbo].[int_param_timetag]
go

DROP INDEX [_dta_index_StatusData_5_1751677288__K3_2_4] ON [dbo].[StatusData]
go

DROP INDEX [_dta_index_StatusData_5_1751677288__K2_K3_1_4_f2] ON [dbo].[StatusData]
go

DROP INDEX [test_group_detail_alias] ON [dbo].[int_test_group_detail]
go

DROP INDEX [IX_int_print_job_et_alarm_deviceSessionId] ON [dbo].[int_print_job_et_alarm]
go

DROP INDEX [ord_group_detail_pk] ON [dbo].[int_order_group_detail]
go

DROP INDEX [idx_PatientSessionsMap_ByPatientId] ON [dbo].[PatientSessionsMap]
go

DROP INDEX [IX_TopicSessions_PatientSessionId] ON [dbo].[TopicSessions]
go

DROP INDEX [IX_TopicSessions_TopicType] ON [dbo].[TopicSessions]
go

DROP INDEX [user_tbl_ndx1] ON [dbo].[int_user]
go

DROP INDEX [user_tbl_ndx2] ON [dbo].[int_user]
go

DROP INDEX [encounter_ndx4] ON [dbo].[int_encounter]
go

DROP INDEX [encounter_ndx3] ON [dbo].[int_encounter]
go

DROP INDEX [encounter_ndx2] ON [dbo].[int_encounter]
go

DROP INDEX [encounter_ndx1] ON [dbo].[int_encounter]
go

DROP INDEX [ord_rank] ON [dbo].[int_order_group]
go

DROP INDEX [person_ndx4] ON [dbo].[int_person]
go

DROP INDEX [person_ndx3] ON [dbo].[int_person]
go

DROP INDEX [pkey_ndx] ON [dbo].[int_flowsheet]
go

DROP INDEX [fs_type_ndx] ON [dbo].[int_flowsheet]
go

DROP INDEX [mrn_map_ndx2] ON [dbo].[int_mrn_map]
go

DROP INDEX [mrn_map_ndx1] ON [dbo].[int_mrn_map]
go

DROP INDEX [mrn_map_ndx3] ON [dbo].[int_mrn_map]
go

DROP INDEX [_dta_index_StatusDataSets_5_1623676832__K2_K3_K4_K1] ON [dbo].[StatusDataSets]
go

DROP INDEX [_dta_index_StatusDataSets_5_1623676832__K2_K1_3_4] ON [dbo].[StatusDataSets]
go

DROP INDEX [_dta_index_StatusDataSets_5_1623676832__K1_2_3_4] ON [dbo].[StatusDataSets]
go

DROP INDEX [_dta_index_StatusDataSets_5_1623676832__K2_K1] ON [dbo].[StatusDataSets]
go

DROP INDEX [_dta_index_StatusDataSets_5_1623676832__K2_K1_4] ON [dbo].[StatusDataSets]
go

DROP INDEX [order_tbl_ndx2] ON [dbo].[int_order]
go

DROP INDEX [order_tbl_ndx1] ON [dbo].[int_order]
go

DROP INDEX [int_alarm_retrieved_ndx1] ON [dbo].[int_alarm_retrieved]
go

DROP INDEX [organization_ndx1] ON [dbo].[int_organization]
go

DROP INDEX [monitor_ndx2] ON [dbo].[int_patient_monitor]
go

DROP INDEX [monitor_ndx] ON [dbo].[int_patient_monitor]
go

DROP INDEX [ord_map_ndx1] ON [dbo].[int_order_map]
go

DROP INDEX [ord_map_ndx2] ON [dbo].[int_order_map]
go

DROP INDEX [account_ndx1] ON [dbo].[int_account]
go

DROP INDEX [person_name_ndx1] ON [dbo].[int_person_name]
go

DROP INDEX [person_name_ndx2] ON [dbo].[int_person_name]
go

DROP INDEX [ndx_gateway] ON [dbo].[int_monitor]
go

DROP INDEX [send_sys_ndx1] ON [dbo].[int_send_sys]
go

DROP INDEX [security_log_ndx1] ON [dbo].[int_audit_log]
go

DROP INDEX [order_line_ndx1] ON [dbo].[int_order_line]
go

DROP INDEX [test_group_parent_node] ON [dbo].[int_test_group]
go

DROP INDEX [test_group_rank] ON [dbo].[int_test_group]
go

DROP INDEX [enc_map_ndx2] ON [dbo].[int_encounter_map]
go

DROP INDEX [enc_map_ndx1] ON [dbo].[int_encounter_map]
go

DROP INDEX [network_ndx] ON [dbo].[int_gateway]
go

DROP INDEX [_dta_index_PatientData_8_2087678485__K2_K19D_3_9] ON [dbo].[PatientData]
go

DROP INDEX [_dta_index4] ON [dbo].[PatientData]
go

DROP INDEX [hl7_in_queue_ndx4] ON [dbo].[hl7_in_queue]
go

DROP INDEX [hl7_in_queue_ndx3] ON [dbo].[hl7_in_queue]
go

DROP INDEX [hl7_in_queue_ndx2] ON [dbo].[hl7_in_queue]
go

DROP INDEX [hl7_in_queue_ndx5] ON [dbo].[hl7_in_queue]
go

DROP INDEX [hl7_in_queue_ndx1] ON [dbo].[hl7_in_queue]
go

DROP INDEX [hcp_ndx1] ON [dbo].[int_hcp]
go

DROP INDEX [int_outbound_queue_ndx1] ON [dbo].[int_outbound_queue]
go

DROP INDEX [int_outbound_queue_ndx2] ON [dbo].[int_outbound_queue]
go

DROP INDEX [IDX_int_savedevent_event_log_1] ON [dbo].[int_savedevent_event_log]
go

DROP INDEX [SavedEvent_idx] ON [dbo].[int_SavedEvent]
go

DROP INDEX [refnmidx] ON [dbo].[int_reference_range]
go

DROP INDEX [specimen_group_pk] ON [dbo].[int_specimen_group]
go

DROP INDEX [dq_mod_dt_idx] ON [dbo].[mpi_decision_queue]
go

DROP INDEX [dl_mod_dt_idx] ON [dbo].[mpi_decision_log]
go

DROP INDEX [dl_matched_idx] ON [dbo].[mpi_decision_log]
go

DROP INDEX [ndx_saved_event] ON [dbo].[int_saved_event]
go

DROP INDEX [print_job_ndx_0] ON [dbo].[int_print_job]
go

DROP INDEX [index_non_cluster_int_print_job] ON [dbo].[int_print_job]
go

DROP INDEX [hl7_out_queue_ndx1] ON [dbo].[hl7_out_queue]
go

DROP INDEX [hl7_out_queue_ndx3] ON [dbo].[hl7_out_queue]
go

DROP INDEX [hl7_out_queue_ndx2] ON [dbo].[hl7_out_queue]
go

DROP INDEX [patient_list_ndx2] ON [dbo].[int_patient_list]
go

DROP INDEX [patient_list_ndx1] ON [dbo].[int_patient_list]
go

DROP INDEX [int_alarm_waveform_ndx1] ON [dbo].[int_alarm_waveform]
go

DROP INDEX [loader_stats_pk] ON [dbo].[int_loader_stats]
go

DROP INDEX [Hl7InboundMessage_MessageHeaderDate_ndx2] ON [dbo].[Hl7InboundMessage]
go

DROP INDEX [Hl7InboundMessage_MessageProcessedDate_ndx3] ON [dbo].[Hl7InboundMessage]
go

DROP INDEX [Hl7InboundMessage_MessageQueuedDate_ndx1] ON [dbo].[Hl7InboundMessage]
go

DROP INDEX [patient_list_detail_ndx1] ON [dbo].[int_patient_list_detail]
go

DROP INDEX [patient_list_detail_ndx2] ON [dbo].[int_patient_list_detail]
go

DROP INDEX [hcp_map_ndx2] ON [dbo].[int_hcp_map]
go

DROP INDEX [hcp_map_ndx1] ON [dbo].[int_hcp_map]
go

DROP INDEX [PacerSpikeLog_idx] ON [dbo].[PacerSpikeLog]
go

DROP INDEX [specimen_ndx1] ON [dbo].[int_specimen]
go

DROP INDEX [specimen_ndx2] ON [dbo].[int_specimen]
go

DROP INDEX [lead_ndx1] ON [dbo].[int_12lead_report]
go

DROP INDEX [int_waveform_ndx1] ON [dbo].[int_waveform]
go

DROP INDEX [int_waveform_ndx3] ON [dbo].[int_waveform]
go

DROP INDEX [waveform_ndx1] ON [dbo].[int_waveform]
go

DROP INDEX [index_int_waveform_patient_start_time] ON [dbo].[int_waveform]
go

DROP INDEX [index_int_waveform_channel_id_end_start] ON [dbo].[int_waveform]
go

DROP INDEX [SavedEventWaveform_idx] ON [dbo].[int_SavedEvent_Waveform]
go

DROP INDEX [msg_log_template_ndx] ON [dbo].[int_msg_log]
go

DROP INDEX [msg_log_idx] ON [dbo].[int_msg_log]
go

DROP INDEX [external_organization_ndx2] ON [dbo].[int_external_organization]
go

DROP INDEX [external_organization_ndx1] ON [dbo].[int_external_organization]
go

DROP INDEX [_idx_Events_2] ON [dbo].[EventsData]
go

DROP INDEX [_idx_Events_3] ON [dbo].[EventsData]
go

DROP INDEX [_idx_Events_4] ON [dbo].[EventsData]
go

DROP INDEX [patient_channel_ndx2] ON [dbo].[int_patient_channel]
go

DROP INDEX [ins_plan_ndx2] ON [dbo].[int_insurance_plan]
go

DROP INDEX [ins_plan_ndx1] ON [dbo].[int_insurance_plan]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_24_6497] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[LiveData4].[TopicInstanceId] as _col_1,  [dbo].[LiveData4].[FeedTypeId] as _col_2,  [dbo].[LiveData4].[TimestampUTC] as _col_3,  [dbo].[LiveData4].[Id] as _col_4,  count_big(*) as _col_5 FROM  [dbo].[LiveData4]  GROUP BY  [dbo].[LiveData4].[TopicInstanceId],  [dbo].[LiveData4].[FeedTypeId],  [dbo].[LiveData4].[TimestampUTC],  [dbo].[LiveData4].[Id]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_24_6497_c_5_221243843__K1_K2_K3_K4] ON [dbo].[_dta_mv_24_6497]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE NONCLUSTERED INDEX [_dta_index__dta_mv_24_6497_5_221243843__K5] ON [dbo].[_dta_mv_24_6497]
(
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_22_1912] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[LiveData1].[TopicInstanceId] as _col_1,  [dbo].[LiveData1].[FeedTypeId] as _col_2,  [dbo].[LiveData1].[TimestampUTC] as _col_3,  [dbo].[LiveData1].[Id] as _col_4,  count_big(*) as _col_5 FROM  [dbo].[LiveData1]  GROUP BY  [dbo].[LiveData1].[TopicInstanceId],  [dbo].[LiveData1].[FeedTypeId],  [dbo].[LiveData1].[TimestampUTC],  [dbo].[LiveData1].[Id]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_22_1912_c_5_173243672__K1_K2_K3_K4] ON [dbo].[_dta_mv_22_1912]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE NONCLUSTERED INDEX [_dta_index__dta_mv_22_1912_5_173243672__K5] ON [dbo].[_dta_mv_22_1912]
(
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_21_8066] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[LiveData3].[TopicInstanceId] as _col_1,  [dbo].[LiveData3].[FeedTypeId] as _col_2,  [dbo].[LiveData3].[TimestampUTC] as _col_3,  [dbo].[LiveData3].[Id] as _col_4,  count_big(*) as _col_5 FROM  [dbo].[LiveData3]  GROUP BY  [dbo].[LiveData3].[TopicInstanceId],  [dbo].[LiveData3].[FeedTypeId],  [dbo].[LiveData3].[TimestampUTC],  [dbo].[LiveData3].[Id]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_21_8066_c_5_157243615__K1_K2_K3_K4] ON [dbo].[_dta_mv_21_8066]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE NONCLUSTERED INDEX [_dta_index__dta_mv_21_8066_5_157243615__K5] ON [dbo].[_dta_mv_21_8066]
(
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_23_4149] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[LiveData2].[TopicInstanceId] as _col_1,  [dbo].[LiveData2].[FeedTypeId] as _col_2,  [dbo].[LiveData2].[TimestampUTC] as _col_3,  [dbo].[LiveData2].[Id] as _col_4,  count_big(*) as _col_5 FROM  [dbo].[LiveData2]  GROUP BY  [dbo].[LiveData2].[TopicInstanceId],  [dbo].[LiveData2].[FeedTypeId],  [dbo].[LiveData2].[TimestampUTC],  [dbo].[LiveData2].[Id]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_23_4149_c_5_189243729__K1_K2_K3_K4] ON [dbo].[_dta_mv_23_4149]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_19_1912] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[WaveformLiveData4].[TypeId] as _col_1,  [dbo].[WaveformLiveData4].[TopicInstanceId] as _col_2,  [dbo].[WaveformLiveData4].[EndTimeUTC] as _col_3,  [dbo].[WaveformLiveData4].[Id] as _col_4,  [dbo].[WaveformLiveData4].[StartTimeUTC] as _col_5,  count_big(*) as _col_6 FROM  [dbo].[WaveformLiveData4]  GROUP BY  [dbo].[WaveformLiveData4].[TypeId],  [dbo].[WaveformLiveData4].[TopicInstanceId],  [dbo].[WaveformLiveData4].[EndTimeUTC],  [dbo].[WaveformLiveData4].[Id],  [dbo].[WaveformLiveData4].[StartTimeUTC]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_19_1912_c_5_93243387__K1_K2_K3_K4_K5] ON [dbo].[_dta_mv_19_1912]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC,
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_20_4149] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[WaveformLiveData3].[TypeId] as _col_1,  [dbo].[WaveformLiveData3].[TopicInstanceId] as _col_2,  [dbo].[WaveformLiveData3].[EndTimeUTC] as _col_3,  [dbo].[WaveformLiveData3].[Id] as _col_4,  [dbo].[WaveformLiveData3].[StartTimeUTC] as _col_5,  count_big(*) as _col_6 FROM  [dbo].[WaveformLiveData3]  GROUP BY  [dbo].[WaveformLiveData3].[TypeId],  [dbo].[WaveformLiveData3].[TopicInstanceId],  [dbo].[WaveformLiveData3].[EndTimeUTC],  [dbo].[WaveformLiveData3].[Id],  [dbo].[WaveformLiveData3].[StartTimeUTC]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_20_4149_c_5_109243444__K1_K2_K3_K4_K5] ON [dbo].[_dta_mv_20_4149]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC,
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_18_8066] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[WaveformLiveData2].[TypeId] as _col_1,  [dbo].[WaveformLiveData2].[TopicInstanceId] as _col_2,  [dbo].[WaveformLiveData2].[EndTimeUTC] as _col_3,  [dbo].[WaveformLiveData2].[Id] as _col_4,  [dbo].[WaveformLiveData2].[StartTimeUTC] as _col_5,  count_big(*) as _col_6 FROM  [dbo].[WaveformLiveData2]  GROUP BY  [dbo].[WaveformLiveData2].[TypeId],  [dbo].[WaveformLiveData2].[TopicInstanceId],  [dbo].[WaveformLiveData2].[EndTimeUTC],  [dbo].[WaveformLiveData2].[Id],  [dbo].[WaveformLiveData2].[StartTimeUTC]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_18_8066_c_5_77243330__K1_K2_K3_K4_K5] ON [dbo].[_dta_mv_18_8066]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC,
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET QUOTED_IDENTIFIER ON
go

SET ARITHABORT ON
go

SET CONCAT_NULL_YIELDS_NULL ON
go

SET ANSI_NULLS ON
go

SET ANSI_PADDING ON
go

SET ANSI_WARNINGS ON
go

SET NUMERIC_ROUNDABORT OFF
go

CREATE VIEW [dbo].[_dta_mv_17_4364] WITH SCHEMABINDING
 AS 
SELECT  [dbo].[WaveformLiveData1].[TypeId] as _col_1,  [dbo].[WaveformLiveData1].[TopicInstanceId] as _col_2,  [dbo].[WaveformLiveData1].[EndTimeUTC] as _col_3,  [dbo].[WaveformLiveData1].[Id] as _col_4,  [dbo].[WaveformLiveData1].[StartTimeUTC] as _col_5,  count_big(*) as _col_6 FROM  [dbo].[WaveformLiveData1]  GROUP BY  [dbo].[WaveformLiveData1].[TypeId],  [dbo].[WaveformLiveData1].[TopicInstanceId],  [dbo].[WaveformLiveData1].[EndTimeUTC],  [dbo].[WaveformLiveData1].[Id],  [dbo].[WaveformLiveData1].[StartTimeUTC]  

go

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

go

CREATE UNIQUE CLUSTERED INDEX [_dta_index__dta_mv_17_4364_c_5_61243273__K1_K2_K3_K4_K5] ON [dbo].[_dta_mv_17_4364]
(
	[_col_1] ASC,
	[_col_2] ASC,
	[_col_3] ASC,
	[_col_4] ASC,
	[_col_5] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

