CREATE TABLE [Archive].[InsurancePlan] (
    [InsurancePlanID]     INT           IDENTITY (1, 1) NOT NULL,
    [PlanCode]            NVARCHAR (30) NULL,
    [PlanTypeCodeID]      INT           NULL,
    [InsuranceCompanyID]  INT           NULL,
    [AgreementTypeCodeID] INT           NULL,
    [NoticeOfAdmitSwitch] BIT           NOT NULL,
    [PlanXID]             NVARCHAR (20) NULL,
    [PreAdmitCertCodeID]  INT           NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_InsurancePlan_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_InsurancePlan_InsurancePlanID] PRIMARY KEY CLUSTERED ([InsurancePlanID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_InsurancePlan_InsurancePlanID]
    ON [Archive].[InsurancePlan]([InsurancePlanID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the insurance plan information used by patients. This stores the actual plans that are used by insurance policies. An insurance policy refers to a plan. An account refers to an insurance policy.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'InsurancePlan';

