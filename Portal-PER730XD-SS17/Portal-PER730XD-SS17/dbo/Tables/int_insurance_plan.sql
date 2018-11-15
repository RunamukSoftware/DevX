CREATE TABLE [dbo].[int_insurance_plan] (
    [plan_id]            UNIQUEIDENTIFIER NOT NULL,
    [plan_cd]            NVARCHAR (30)    NULL,
    [plan_type_cid]      INT              NULL,
    [ins_company_id]     UNIQUEIDENTIFIER NULL,
    [agreement_type_cid] INT              NULL,
    [notice_of_admit_sw] NCHAR (1)        NULL,
    [plan_xid]           NVARCHAR (20)    NULL,
    [preadmit_cert_cid]  INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_insurance_plan_plan_id]
    ON [dbo].[int_insurance_plan]([plan_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the insurance plan information used by patients. This stores the actual plans that are used by insurance policies. An insurance policy refers to a plan. An account refers to an insurance policy.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_insurance_plan';

