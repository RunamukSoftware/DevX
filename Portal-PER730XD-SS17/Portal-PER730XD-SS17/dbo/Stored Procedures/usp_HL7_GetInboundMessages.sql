CREATE PROCEDURE [dbo].[usp_HL7_GetInboundMessages]
AS
BEGIN
    SELECT
        [HL7Msg].[MessageNo],
        [HL7Msg].[MessageType],
        [HL7Msg].[MessageTypeEventCode],
        [HL7Msg].[MessageControlId],
        [HL7Msg].[MessageHeaderDate],
        [HL7Msg].[MessageVersion],
        [Map].[mrn_xid] AS [PatientMrn],
        [Map].[mrn_xid2] AS [AccountNumber],
        [Pat].[patient_id] AS [PatientId],
        [Visit].[account_id] AS [AccountId],
        [Pat].[dob] AS [DateOfBirth],
        [Pat].[gender_cid] AS [GenderId],
        [MSCodeGender].[code] AS [PatientGender],
        [PER].[first_nm] AS [FirstName],
        [PER].[last_nm] AS [LastName],
        [PER].[middle_nm] AS [MiddleName],
        [Visit].[admit_dt] AS [PatientAdmitedDate],
        [ORG].[organization_cd] AS [Unit],
        [Visit].[vip_sw] AS [Vip],
        [Visit].[rm] AS [Room],
        [Visit].[bed] AS [Bed],
        [Visit].[patient_class_cid] AS [PatientClassId],
        [MSCodePatClass].[code] AS [PatientClass],
        [VisitMap].[encounter_xid],
        [Visit].[discharge_dt] AS [DischargeDateTime]
    FROM
        [dbo].[HL7InboundMessage] AS [HL7Msg]
        INNER JOIN [dbo].[HL7PatientLink] AS [HL7Link] ON [HL7Link].[MessageNo] = [HL7Msg].[MessageNo]
        INNER JOIN [dbo].[int_mrn_map] AS [Map] ON [Map].[mrn_xid] = [HL7Link].[PatientMrn]
        INNER JOIN [dbo].[int_patient] AS [Pat] ON [Pat].[patient_id] = [Map].[patient_id]
        INNER JOIN [dbo].[int_person] AS [PER] ON [PER].[person_id] = [Pat].[patient_id]
        INNER JOIN [dbo].[int_encounter] AS [Visit] ON [Visit].[patient_id] = [Map].[patient_id]
        INNER JOIN [dbo].[int_encounter_map] AS [VisitMap] ON [VisitMap].[encounter_id] = [Visit].[encounter_id]
        INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [Visit].[unit_org_id]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [MSCodeGender] ON [MSCodeGender].[code_id] = [Pat].[gender_cid]
                                                             AND [MSCodeGender].[category_cd] = 'SEX'
                                                             AND [MSCodeGender].[method_cd] = N'HL7'
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [MSCodePatClass] ON [MSCodePatClass].[code_id] = [Visit].[patient_class_cid]
                                                               AND [MSCodePatClass].[category_cd] = 'PCLS'
                                                               AND [MSCodePatClass].[method_cd] = N'HL7';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient details inserted from ADTA01.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetInboundMessages';

