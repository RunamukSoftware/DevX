CREATE TABLE [dbo].[int_specimen] (
    [specimen_id]              UNIQUEIDENTIFIER NOT NULL,
    [order_id]                 UNIQUEIDENTIFIER NOT NULL,
    [patient_id]               UNIQUEIDENTIFIER NULL,
    [orig_patient_id]          UNIQUEIDENTIFIER NULL,
    [univ_svc_cid]             INT              NULL,
    [status_cid]               INT              NULL,
    [encounter_id]             UNIQUEIDENTIFIER NULL,
    [collect_id]               UNIQUEIDENTIFIER NULL,
    [specimen_xid]             NVARCHAR (15)    NULL,
    [procedure_dt]             DATETIME         NULL,
    [source_cid]               INT              NULL,
    [body_site_cid]            INT              NULL,
    [comment_id]               UNIQUEIDENTIFIER NULL,
    [collect_dt]               DATETIME         NULL,
    [collect_vol_qty]          SMALLINT         NULL,
    [collect_vol_unit_code_id] CHAR (10)        NULL,
    [collect_method]           NVARCHAR (80)    NULL,
    [source_additive]          NVARCHAR (30)    NULL,
    [action_code_id]           CHAR (1)         NULL,
    [call_back_phone_cat_id]   INT              NULL,
    [fields_key]               INT              NULL,
    [receive_dt]               DATETIME         NULL,
    [handle_cid]               INT              NULL,
    [handle_cat_cid]           INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_specimen_specimen_id_patient_id]
    ON [dbo].[int_specimen]([specimen_id] ASC, [patient_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to capture information of the SPECIMEN that is associated with the performable test. The important information are the type, source, and when the SPECIMEN was collected. The test processing generally is categorized by the SPECIMEN type. Blood related SPECIMEN usually process in hemetology section, etc.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_specimen';

