CREATE TABLE [dbo].[int_encounter] (
    [encounter_id]        UNIQUEIDENTIFIER NOT NULL,
    [organization_id]     UNIQUEIDENTIFIER NULL,
    [mod_dt]              DATETIME         NULL,
    [patient_id]          UNIQUEIDENTIFIER NULL,
    [orig_patient_id]     UNIQUEIDENTIFIER NULL,
    [account_id]          UNIQUEIDENTIFIER NULL,
    [status_cd]           NVARCHAR (3)     NULL,
    [publicity_cid]       INT              NULL,
    [diet_type_cid]       INT              NULL,
    [patient_class_cid]   INT              NULL,
    [protection_type_cid] INT              NULL,
    [vip_sw]              NCHAR (2)        NULL,
    [isolation_type_cid]  INT              NULL,
    [security_type_cid]   INT              NULL,
    [patient_type_cid]    INT              NULL,
    [admit_hcp_id]        UNIQUEIDENTIFIER NULL,
    [med_svc_cid]         INT              NULL,
    [referring_hcp_id]    UNIQUEIDENTIFIER NULL,
    [unit_org_id]         UNIQUEIDENTIFIER NULL,
    [attend_hcp_id]       UNIQUEIDENTIFIER NULL,
    [primary_care_hcp_id] UNIQUEIDENTIFIER NULL,
    [fall_risk_type_cid]  INT              NULL,
    [begin_dt]            DATETIME         NULL,
    [ambul_status_cid]    INT              NULL,
    [admit_dt]            DATETIME         NULL,
    [baby_cd]             NCHAR (1)        NULL,
    [rm]                  NVARCHAR (80)    NULL,
    [recurring_cd]        NCHAR (1)        NULL,
    [bed]                 NCHAR (80)       NULL,
    [discharge_dt]        DATETIME         NULL,
    [newborn_sw]          NCHAR (1)        NULL,
    [discharge_dispo_cid] INT              NULL,
    [monitor_created]     TINYINT          NULL,
    [comment]             NTEXT            NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_encounter_encounter_id]
    ON [dbo].[int_encounter]([encounter_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_encounter_account_id]
    ON [dbo].[int_encounter]([account_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_encounter_patient_id]
    ON [dbo].[int_encounter]([patient_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_encounter_rm]
    ON [dbo].[int_encounter]([rm] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_encounter_discharge_dt]
    ON [dbo].[int_encounter]([discharge_dt] ASC) WITH (FILLFACTOR = 100);


GO
-- Description: Creates the mapping between int_account and int_encounter table
CREATE TRIGGER [dbo].[trg_int_encounter_HL7_Update_Map_AccountNumber_Encounter] ON [dbo].[int_encounter]
--WITH EXECUTE AS CALLER
    AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @act_guid UNIQUEIDENTIFIER,
        @org_guid UNIQUEIDENTIFIER,
        @pat_guid UNIQUEIDENTIFIER;
      
    --Get the account id from int_account table by account_xid and mrn_xid2 map
    SELECT
        @act_guid = [ACCOUNT].[account_id],
        @org_guid = [ACCOUNT].[organization_id],
        @pat_guid = [Inserted].[patient_id]
    FROM
        [Inserted]
        INNER JOIN [dbo].[int_mrn_map] AS [MAP] ON [MAP].[patient_id] = [Inserted].[patient_id]
        INNER JOIN [dbo].[int_account] AS [ACCOUNT] ON [ACCOUNT].[account_xid] = [MAP].[mrn_xid2]
    WHERE
        ([Inserted].[discharge_dt] IS NULL)
        AND ([Inserted].[status_cd] = N'C');
      
    --Update the account id in the encounter.
    UPDATE
        [dbo].[int_encounter]
    SET
        [account_id] = @act_guid
    WHERE
        [patient_id] = @pat_guid
        AND [status_cd] = N'C'
        AND [monitor_created] = 1
        AND [organization_id] = @org_guid;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all encounters for each patient. Most of this information comes from the HL/7 PV1 & PV2 segments. Usually an encounter represents a single "visit" or "stay" at a facility. Although a site can define an encounter to be broader (i.e. multiple actual visits) or a sub-set of an entire "visit". 99% of the time, encounter and visit are synonymous.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the unique system-generated ID for each encounter. It is a random GUID.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the ORGANIZATION table. This is the facility where the encounter was "serviced".', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'organization_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The last date/time the encounter was modified.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'mod_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient this encounter is associated with. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The account associated with this encounter. FK to the account table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'account_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the type of ENCOUNTER.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'status_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains a code that defines what level of publicity is allowed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'publicity_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates a special diet type for a patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'diet_type_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the PATIENT category at the time of the ENCOUNTER.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'patient_class_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field id''s the person''s protection that determines, in turn, whether access to info. abut this person should be kept from unauthorized users.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'protection_type_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether person is a VIP.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'vip_sw';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field contains site-specific values that identify the patient type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'patient_type_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The admitting HCP for this encounter. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'admit_hcp_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the medical service that is provided. Ex: MED, SUR, OBS, NUR, EYE, CLI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'med_svc_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the HCP table. The referring HCP.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'referring_hcp_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the location of the PATIENT at the time that the ENCOUNTER is ''assigned''. This includes the Nursing Unit, Ancillary Departments, or temporary locations.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'unit_org_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the HCP table. The attending HCP.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'attend_hcp_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The primary care physician of the patient at the time of this encounter. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'primary_care_hcp_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date from the MSH segment for the message that actually caused the encounter row to get inserted into the database.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'begin_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that indicates the PATIENT''s transportation capabilities. Refer to HL7, table 0009 for all values and  descriptions.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'ambul_status_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The admission date and time in which the PATIENT interacts with an HEALTHCARE PROVIDER. For Pre-admit class, it is the scheduled admit date.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'admit_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether the patient is a baby.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'baby_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The room that the patient is currently in (or was last in) for the encounter.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'rm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates whether the treatment is continuous.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'recurring_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The bed that the patient is in (or was last in).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'bed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the patient was discharged.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'discharge_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the int_misc_code table. The discharge disposition of this encounter.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'discharge_dispo_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If True (1), then this encounter was created by a Monitor Loader (gateway). This is helpful when trying to re-locate a specific encounter associated with a connection epsiode.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'monitor_created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A comment that can be associated with this encounter.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter', @level2type = N'COLUMN', @level2name = N'comment';

