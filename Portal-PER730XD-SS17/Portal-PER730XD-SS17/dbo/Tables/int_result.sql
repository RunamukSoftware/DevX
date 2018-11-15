CREATE TABLE [dbo].[int_result] (
    [result_id]          UNIQUEIDENTIFIER NOT NULL,
    [patient_id]         UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]    UNIQUEIDENTIFIER NULL,
    [obs_start_dt]       DATETIME         NULL,
    [order_id]           UNIQUEIDENTIFIER NOT NULL,
    [is_history]         TINYINT          NULL,
    [monitor_sw]         TINYINT          NULL,
    [univ_svc_cid]       INT              NOT NULL,
    [test_cid]           INT              NOT NULL,
    [history_seq]        INT              NULL,
    [test_sub_id]        NVARCHAR (20)    NULL,
    [order_line_seq_no]  SMALLINT         NULL,
    [test_result_seq_no] SMALLINT         NULL,
    [result_dt]          DATETIME         NULL,
    [value_type_cd]      NVARCHAR (10)    NULL,
    [specimen_id]        UNIQUEIDENTIFIER NULL,
    [source_cid]         INT              NULL,
    [status_cid]         INT              NULL,
    [last_normal_dt]     DATETIME         NULL,
    [probability]        FLOAT (53)       NULL,
    [obs_id]             UNIQUEIDENTIFIER NULL,
    [prin_rslt_intpr_id] UNIQUEIDENTIFIER NULL,
    [asst_rslt_intpr_id] UNIQUEIDENTIFIER NULL,
    [tech_id]            UNIQUEIDENTIFIER NULL,
    [trnscrbr_id]        UNIQUEIDENTIFIER NULL,
    [result_units_cid]   INT              NULL,
    [reference_range_id] INT              NULL,
    [abnormal_cd]        NVARCHAR (10)    NULL,
    [abnormal_nature_cd] NVARCHAR (10)    NULL,
    [prov_svc_cid]       INT              NULL,
    [nsurv_tfr_ind]      NVARCHAR (10)    NULL,
    [result_value]       NVARCHAR (255)   NULL,
    [result_text]        NTEXT            NULL,
    [result_comment]     NTEXT            NULL,
    [has_history]        TINYINT          NULL,
    [mod_dt]             DATETIME         NULL,
    [mod_user_id]        UNIQUEIDENTIFIER NULL,
    [Sequence]           BIGINT           IDENTITY (0, 1) NOT FOR REPLICATION NOT NULL,
    [result_ft]          BIGINT           NULL,
    CONSTRAINT [PK_int_result_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);




GO
CREATE NONCLUSTERED INDEX [IX_int_result_obs_start_dt]
    ON [dbo].[int_result]([obs_start_dt] ASC) WITH (FILLFACTOR = 100);


GO



GO
CREATE NONCLUSTERED INDEX [IX_int_result_patient_id_test_cid_result_ft_result_dt_result_value]
    ON [dbo].[int_result]([patient_id] ASC, [test_cid] ASC, [result_ft] DESC)
    INCLUDE([result_dt], [result_value]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Result-based information, most of which comes from OBX segments. The CUR_RSLT_xxxx table holds all current results, hence the name. When a result is updated the original CUR_RSLT_xxxx is copied into the HIST_RSLT_xxxx table. The two tables are exactly the same to facilitate easily coping one table to the other. Seven current result data stores are used by CDR: - CUR_RSLT_LAB (Laboratory/Microbiology) - CUR_RSLT_RAD (Radiology/X-ray/Nuclear Medicine) - CUR_RSLT_VITL (Vital Signs/Statistics) - CUR_RSLT_RPT (Reports/Transcriptions/Progress Reports) - CUR_RSLT_IO (Intake/Ouput) - CUR_RSLT_ASSMT (Nursing Assessments) - CUR_RSLT_ECG (Ecg) In the HIST_RSLT_xxxx table the DESC_KEY should be used to display reverse chronological history of changes. Note that the DESC_KEY is a surrogate primary key for all result tables. HL7 to database mappings: ORC -> ORDER_TBL OBR -> ORDER_LINE,SPECIMEN OBX -> CUR_RSLT_xxxx Relationship between tests and results: Panels and Test Groups: Panels and Test Groups must be transmitted in OBR segments, since the ORC does not contain any type of identifier or name, the ORC is entirely optional in ORUs, and the OBX only contains TEST/RESULTS. In the database, we do not deal with these since HL7 does not transmit enough information to determine the relationships necessary. The ORDER_TBL has two fields that attempt to deal with order groups at a gross level, PARENT_ORD_ID and CHILD_ORD_SW. When ORDER ENTRY is developed this will need to be re-investigated. Batteries: Batteries are collections of tests that are given a single name and are generally ordered (i.e. OBR''s). An HL7 battery is equivalent to a display panel. Each battery processed by CDR will have a unique battery_id value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_result';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Seuqence of data insertion', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_result', @level2type = N'COLUMN', @level2name = N'Sequence';

