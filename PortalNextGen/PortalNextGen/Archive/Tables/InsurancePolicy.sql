CREATE TABLE [Archive].[InsurancePolicy] (
    [InsurancePolicyID]           INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]                   INT           NOT NULL,
    [SequenceNumber]              SMALLINT      NOT NULL,
    [ActiveSwitch]                BIT           NOT NULL,
    [OriginalPatientID]           INT           NOT NULL,
    [AccountID]                   INT           NOT NULL,
    [InsurancePolicyXID]          NVARCHAR (20) NOT NULL,
    [HolderID]                    INT           NOT NULL,
    [HolderRelationshipCodeID]    INT           NOT NULL,
    [HolderEmployerID]            INT           NOT NULL,
    [InsurancePlanID]             INT           NOT NULL,
    [GroupXID]                    NVARCHAR (20) NOT NULL,
    [GroupName]                   NVARCHAR (35) NOT NULL,
    [CompanyPlanCodeID]           NVARCHAR (8)  NOT NULL,
    [PlanEffectiveDateTime]       DATETIME2 (7) NOT NULL,
    [PlanExpirationDateTime]      DATETIME2 (7) NOT NULL,
    [verifyDateTime]              DATETIME2 (7) NOT NULL,
    [PolicyDeductibleAmount]      MONEY         NOT NULL,
    [PolicyLimitAmount]           MONEY         NOT NULL,
    [PolicyLimitDaysNumber]       SMALLINT      NOT NULL,
    [RoomSemiPrivateRate]         MONEY         NOT NULL,
    [RoomPrivateRate]             MONEY         NOT NULL,
    [AuthorizationNumber]         NVARCHAR (20) NOT NULL,
    [AuthorizationDateTime]       DATETIME2 (7) NOT NULL,
    [AuthorizationSource]         NVARCHAR (4)  NOT NULL,
    [AuthorizationCommentID]      INT           NOT NULL,
    [CobPriority]                 TINYINT       NOT NULL,
    [CobCode]                     NCHAR (2)     NOT NULL,
    [BillingStatusCode]           NCHAR (3)     NOT NULL,
    [ReportOfEligibilitySwitch]   BIT           NOT NULL,
    [ReportOfEligibilityDateTime] DATETIME2 (7) NOT NULL,
    [AssignmentOfBenefitsSwitch]  BIT           NOT NULL,
    [NoticeOfAdmitDateTime]       DATETIME2 (7) NOT NULL,
    [VerifyID]                    INT           NOT NULL,
    [LifetimeReserveDaysNumber]   SMALLINT      NOT NULL,
    [DelayBefore_lr_DayNumber]    SMALLINT      NOT NULL,
    [InsuranceContactID]          INT           NOT NULL,
    [PlanXID]                     NVARCHAR (20) NOT NULL,
    [CreatedDateTime]             DATETIME2 (7) CONSTRAINT [DF_InsurancePolicy_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_InsurancePolicy_InsurancePolicyID] PRIMARY KEY CLUSTERED ([InsurancePolicyID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_InsurancePolicy_InsurancePlan_InsurancePlanID] FOREIGN KEY ([InsurancePlanID]) REFERENCES [Archive].[InsurancePlan] ([InsurancePlanID]),
    CONSTRAINT [FK_InsurancePolicy_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_InsurancePolicy_PatientID_AccountID_ActiveSwitch_SequenceNumber_cob_priority]
    ON [Archive].[InsurancePolicy]([PatientID] ASC, [AccountID] ASC, [ActiveSwitch] ASC, [SequenceNumber] ASC, [CobPriority] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the insurance policies that are referenced in patient accounts.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'InsurancePolicy';

