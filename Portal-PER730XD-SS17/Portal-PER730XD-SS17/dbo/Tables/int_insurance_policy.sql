CREATE TABLE [dbo].[int_insurance_policy] (
    [patient_id]                UNIQUEIDENTIFIER NOT NULL,
    [seq_no]                    SMALLINT         NOT NULL,
    [active_sw]                 TINYINT          NULL,
    [orig_patient_id]           UNIQUEIDENTIFIER NULL,
    [account_id]                UNIQUEIDENTIFIER NULL,
    [ins_policy_xid]            NVARCHAR (20)    NULL,
    [holder_id]                 UNIQUEIDENTIFIER NULL,
    [holder_rel_cid]            INT              NULL,
    [holder_emp_id]             UNIQUEIDENTIFIER NULL,
    [plan_id]                   UNIQUEIDENTIFIER NULL,
    [group_xid]                 NVARCHAR (20)    NULL,
    [group_nm]                  NVARCHAR (35)    NULL,
    [company_plan_cid]          NVARCHAR (8)     NULL,
    [plan_eff_dt]               DATETIME         NULL,
    [plan_exp_dt]               DATETIME         NULL,
    [verify_dt]                 DATETIME         NULL,
    [plcy_deductible_amt]       MONEY            NULL,
    [plcy_limit_amt]            MONEY            NULL,
    [plcy_limit_days_no]        SMALLINT         NULL,
    [rm_semi_private_rt]        MONEY            NULL,
    [rm_private_rt]             MONEY            NULL,
    [authorization_no]          NVARCHAR (20)    NULL,
    [authorization_dt]          DATETIME         NULL,
    [authorization_source]      NVARCHAR (4)     NULL,
    [authorization_cmt_id]      UNIQUEIDENTIFIER NULL,
    [cob_priority]              TINYINT          NULL,
    [cob_code]                  NCHAR (2)        NULL,
    [billing_status_code]       NCHAR (3)        NULL,
    [rpt_of_eligibility_sw]     TINYINT          NULL,
    [rpt_of_eligibility_dt]     DATETIME         NULL,
    [assignment_of_benefits_sw] NCHAR (2)        NULL,
    [notice_of_admit_dt]        DATETIME         NULL,
    [verify_id]                 UNIQUEIDENTIFIER NULL,
    [lifetm_reserve_days_no]    SMALLINT         NULL,
    [delay_before_lr_day_no]    SMALLINT         NULL,
    [ins_contact_id]            UNIQUEIDENTIFIER NULL,
    [plan_xid]                  NVARCHAR (20)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_insurance_policy_patient_id_account_id_active_sw_seq_no_cob_priority]
    ON [dbo].[int_insurance_policy]([patient_id] ASC, [account_id] ASC, [active_sw] ASC, [seq_no] ASC, [cob_priority] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the insurance policies that are referenced in patient accounts.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_insurance_policy';

