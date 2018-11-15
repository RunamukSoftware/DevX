CREATE PROCEDURE [HL7].[uspGetInboundMessages]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [HL7Msg].[MessageNumber],
            [HL7Msg].[MessageType],
            [HL7Msg].[MessageTypeEventCode],
            [HL7Msg].[MessageControlID],
            [HL7Msg].[MessageHeaderDate],
            [HL7Msg].[MessageVersion],
            [Map].[MedicalRecordNumberXID]  AS [PatientMedicalRecordNumber],
            [Map].[MedicalRecordNumberXID2] AS [AccountNumber],
            [Pat].[PatientID]               AS [PatientID],
            [Visit].[AccountID]             AS [AccountID],
            [Pat].[DateOfBirth]             AS [DateOfBirth],
            [Pat].[GenderCodeID]            AS [GenderID],
            [MSCodeGender].[Code]           AS [PatientGender],
            [PER].[FirstName]               AS [FirstName],
            [PER].[LastName]                AS [LastName],
            [PER].[MiddleName]              AS [MiddleName],
            [Visit].[AdmitDateTime]         AS [PatientAdmitedDate],
            [ORG].[OrganizationCode]        AS [Unit],
            [Visit].[VipSwitch]             AS [Vip],
            [Visit].[Room]                  AS [Room],
            [Visit].[Bed]                   AS [Bed],
            [Visit].[PatientClassCodeID]    AS [PatientClassID],
            [MSCodePatClass].[Code]         AS [PatientClass],
            [VisitMap].[EncounterXID],
            [Visit].[DischargeDateTime]     AS [DischargeDateTime]
        FROM
            [HL7].[InboundMessage]                 AS [HL7Msg]
            INNER JOIN
                [HL7].[PatientLink]                AS [HL7Link]
                    ON [HL7Link].[MessageNumber] = [HL7Msg].[MessageNumber]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [Map]
                    ON [Map].[MedicalRecordNumberXID] = [HL7Link].[PatientMedicalRecordNumber]
            INNER JOIN
                [Intesys].[Patient]                AS [Pat]
                    ON [Pat].[PatientID] = [Map].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [PER]
                    ON [PER].[PersonID] = [Pat].[PatientID]
            INNER JOIN
                [Intesys].[Encounter]              AS [Visit]
                    ON [Visit].[PatientID] = [Map].[PatientID]
            INNER JOIN
                [Intesys].[EncounterMap]           AS [VisitMap]
                    ON [VisitMap].[EncounterID] = [Visit].[EncounterID]
            INNER JOIN
                [Intesys].[Organization]           AS [ORG]
                    ON [ORG].[OrganizationID] = [Visit].[UnitOrganizationID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [MSCodeGender]
                    ON [MSCodeGender].[CodeID] = [Pat].[GenderCodeID]
                       AND [MSCodeGender].[CategoryCode] = 'SEX'
                       AND [MSCodeGender].[MethodCode] = N'HL7'
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [MSCodePatClass]
                    ON [MSCodePatClass].[CodeID] = [Visit].[PatientClassCodeID]
                       AND [MSCodePatClass].[CategoryCode] = 'PCLS'
                       AND [MSCodePatClass].[MethodCode] = N'HL7';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient details inserted from ADTA01.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetInboundMessages';

