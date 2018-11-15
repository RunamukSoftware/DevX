CREATE TABLE [Intesys].[Encounter] (
    [EncounterID]                     INT            IDENTITY (1, 1) NOT NULL,
    [OrganizationID]                  INT            NOT NULL,
    [PatientID]                       INT            NOT NULL,
    [OriginalPatientID]               INT            NULL,
    [AccountID]                       INT            NOT NULL,
    [StatusCode]                      NVARCHAR (3)   NOT NULL,
    [PublicityCodeID]                 INT            NOT NULL,
    [DietTypeCodeID]                  INT            NOT NULL,
    [PatientClassCodeID]              INT            NOT NULL,
    [ProtectionTypeCodeID]            INT            NOT NULL,
    [VipSwitch]                       BIT            NOT NULL,
    [IsolationTypeCodeID]             INT            NOT NULL,
    [SecurityTypeCodeID]              INT            NOT NULL,
    [PatientTypeCodeID]               INT            NOT NULL,
    [AdmitHealthCareProviderID]       INT            NOT NULL,
    [MedicalServiceCodeID]            INT            NOT NULL,
    [ReferringHealthCareProviderID]   INT            NOT NULL,
    [UnitOrganizationID]              INT            NOT NULL,
    [AttendHealthCareProviderID]      INT            NOT NULL,
    [PrimaryCareHealthCareProviderID] INT            NOT NULL,
    [FallRiskTypeCodeID]              INT            NOT NULL,
    [BeginDateTime]                   DATETIME2 (7)  NOT NULL,
    [AmbulatoryStatusCodeID]          INT            NOT NULL,
    [AdmitDateTime]                   DATETIME2 (7)  NOT NULL,
    [BabyCode]                        NCHAR (1)      NOT NULL,
    [Room]                            NVARCHAR (80)  NOT NULL,
    [RecurringCode]                   NCHAR (1)      NOT NULL,
    [Bed]                             NCHAR (80)     NOT NULL,
    [DischargeDateTime]               DATETIME2 (7)  NOT NULL,
    [NewbornSwitch]                   NCHAR (1)      NOT NULL,
    [DischargeDispositionCodeID]      INT            NOT NULL,
    [MonitorCreated]                  TINYINT        NOT NULL,
    [Comment]                         NVARCHAR (MAX) NOT NULL,
    [ModifiedDateTime]                DATETIME2 (7)  NOT NULL,
    [CreatedDateTime]                 DATETIME2 (7)  CONSTRAINT [DF_Encounter_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Encounter_EncounterID] PRIMARY KEY CLUSTERED ([EncounterID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Encounter_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID]),
    CONSTRAINT [FK_Encounter_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Encounter_DischargeDateTime]
    ON [Intesys].[Encounter]([DischargeDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Encounter_PatientID]
    ON [Intesys].[Encounter]([PatientID] ASC) WITH (FILLFACTOR = 100);


GO
-- Description: Creates the mapping between int_account and int_encounter table
CREATE TRIGGER [Intesys].[trgEncounterUpdateMapAccountNumberEncounter]
ON [Intesys].[Encounter]
--WITH EXECUTE AS CALLER
AFTER INSERT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @AccountID      INT,
            @OrganizationID INT,
            @PatientID      INT;

        --Get the account id from int_account table by AccountXID and MedicalRecordNumberXID2 map
        SELECT
            @AccountID      = [ia].[AccountID],
            @OrganizationID = [ia].[OrganizationID],
            @PatientID      = [i].[PatientID]
        FROM
            [Inserted]                             AS [i]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [imm].[PatientID] = [i].[PatientID]
            INNER JOIN
                [Intesys].[Account]                AS [ia]
                    ON [ia].[AccountXID] = [imm].[MedicalRecordNumberXID2]
        WHERE
            [i].[DischargeDateTime] IS NULL
            AND [i].[StatusCode] = N'C';

        --Update the account id in the encounter.
        UPDATE
            [Intesys].[Encounter]
        SET
            [AccountID] = @AccountID
        FROM
            [Intesys].[Encounter] AS [ie]
        WHERE
            [ie].[PatientID] = @PatientID
            AND [ie].[StatusCode] = N'C'
            AND [ie].[MonitorCreated] = 1
            AND [ie].[OrganizationID] = @OrganizationID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all encounters for each patient. Most of this information comes from the HL/7 PV1 & PV2 segments. Usually an encounter represents a single "visit" or "stay" at a facility. Although a site can define an encounter to be broader (i.e. multiple actual visits) or a sub-set of an entire "visit". 99% of the time, encounter and visit are synonymous.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the unique system-generated ID for each encounter. It is a random GUID.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the ORGANIZATION table. This is the facility where the encounter was "serviced".', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'OrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient this encounter is associated with. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The account associated with this encounter. FK to the account table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'AccountID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the Type of ENCOUNTER.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'StatusCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains a code that defines what level of publicity is allowed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'PublicityCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates a special diet Type for a patient.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'DietTypeCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the PATIENT category at the time of the ENCOUNTER.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'PatientClassCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field id''s the person''s protection that determines, in turn, whether access to info. abut this person should be kept from unauthorized users.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'ProtectionTypeCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether person is a VIP.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'VipSwitch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field contains site-specific values that identify the patient Type.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'PatientTypeCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The admitting HCP for this encounter. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'AdmitHealthCareProviderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the medical service that is provided. Ex: MED, SUR, OBS, NUR, EYE, CLI', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'MedicalServiceCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the HCP table. The referring HCP.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'ReferringHealthCareProviderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the location of the PATIENT at the time that the ENCOUNTER is ''assigned''. This includes the Nursing Unit, Ancillary Departments, or temporary locations.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'UnitOrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the HCP table. The attending HCP.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'AttendHealthCareProviderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The primary care physician of the patient at the time of this encounter. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'PrimaryCareHealthCareProviderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date from the MSH segment for the message that actually caused the encounter row to get inserted into the database.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'BeginDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that indicates the PATIENT''s transportation capabilities. Refer to HL7, table 0009 for all values and  descriptions.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'AmbulatoryStatusCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The admission date and time in which the PATIENT interacts with an HEALTHCARE PROVIDER. For Pre-admit class, it is the scheduled admit date.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'AdmitDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether the patient is a baby.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'BabyCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The room that the patient is currently in (or was last in) for the encounter.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'Room';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates whether the treatment is continuous.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'RecurringCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The bed that the patient is in (or was last in).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'Bed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date/time the patient was discharged.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'DischargeDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the int_misc_code table. The discharge disposition of this encounter.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'DischargeDispositionCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If True (1), then this encounter was created by a Monitor Loader (gateway). This is helpful when trying to re-locate a specific encounter associated with a connection epsiode.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'MonitorCreated';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A comment that can be associated with this encounter.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'Comment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The last date/time the encounter was modified.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Encounter', @level2type = N'COLUMN', @level2name = N'ModifiedDateTime';

