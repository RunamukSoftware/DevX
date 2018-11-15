CREATE TABLE [dbo].[int_order_line] (
    [order_id]           UNIQUEIDENTIFIER NOT NULL,
    [seq_no]             SMALLINT         NOT NULL,
    [patient_id]         UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]    UNIQUEIDENTIFIER NULL,
    [status_cid]         INT              NULL,
    [prov_svc_cid]       INT              NULL,
    [univ_svc_cid]       INT              NULL,
    [transport_cid]      INT              NULL,
    [order_line_comment] NTEXT            NULL,
    [clin_info_comment]  NTEXT            NULL,
    [reason_comment]     NTEXT            NULL,
    [scheduled_dt]       DATETIME         NULL,
    [observ_dt]          DATETIME         NULL,
    [status_chg_dt]      DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_order_line_order_id_univ_svc_cid_patient_id_seq_no]
    ON [dbo].[int_order_line]([order_id] ASC, [univ_svc_cid] ASC, [patient_id] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The request for a specific service. One detailed entry of an ORDER requesting an instance of a service. The ORDER_LINE entity type is used to hold individual orderable items within an ORDER. It is the detail of an order. Deleted Columns: priority_code_id, ord_cntl_code_id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_order_line';

