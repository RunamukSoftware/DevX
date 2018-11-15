CREATE PROCEDURE [old].[uspEncountersDetails] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @AccountNumber CHAR(40)     = 'SEE DETAIL',
            @Diagnosis     VARCHAR(255) = ' ',
            @PatientType   VARCHAR(30)  = '',
            @PatientClass  VARCHAR(30)  = '';

        SELECT DISTINCT
            @AccountNumber                    AS [TMP_ACCT_XID],
            [ie].[AccountID]                  AS [TMP_ACCTID],
            [ie].[EncounterID]                AS [TMP_ENCID],
            [iem].[EncounterXID]              AS [TMP_ENC_XID],
            [ie].[PatientTypeCodeID]          AS [TMP_PAT_TYPEID],
            @PatientType                      AS [TMP_PAT_TYPE],
            [ie].[PatientClassCodeID]         AS [TMP_PAT_CLASSID],
            @PatientClass                     AS [TMP_PAT_CLASS],
            [ie].[AdmitDateTime]              AS [TMP_AdmitDateTime],
            [ie].[DischargeDateTime]          AS [TMP_DischargeDateTime],
            [ie].[MedicalServiceCodeID]       AS [TMP_MED_SRVCID],
            SPACE(20)                         AS [TMP_MED_SRVC],
            0                                 AS [TMP_DIAGID],
            @Diagnosis                        AS [TMP_DIAGNOSIS],
            [ie].[AttendHealthCareProviderID] AS [TMP_DRID],
            [ie].[StatusCode]                 AS [TMP_ENC_StatusCode],
            [ih].[LastName]                   AS [TMP_DR_LAST_NAME],
            [ih].[FirstName]                  AS [TMP_DR_FIRST_NAME],
            [ih].[MiddleName]                 AS [TMP_DR_MIDDLE_NAME],
            [iem].[StatusCode]                AS [TMP_ENC_MAP_StatusCode],
            [iem].[EventCode]                 AS [TMP_STAT_ACT_CODE],
            [ie].[VipSwitch]                  AS [TMP_VIPSwitch],
            SPACE(20)                         AS [TMP_DEPT_CODE],
            [ie].[UnitOrganizationID]         AS [TMP_DEPTID],
            [ie].[Room]                       AS [TMP_ROOM],
            [ie].[Bed]                        AS [TMP_BED],
            [ie].[DischargeDispositionCodeID] AS [TMP_DispositionCodeID]
        INTO
            [#Encounter]
        FROM
            [Intesys].[Encounter]              AS [ie]
            LEFT OUTER JOIN
                [Intesys].[HealthCareProvider] AS [ih]
                    ON [ie].[AttendHealthCareProviderID] = [ih].[HealthCareProviderID]
            INNER JOIN
                [Intesys].[EncounterMap]       AS [iem]
                    ON [iem].[EncounterID] = [ie].[EncounterID]
        WHERE
            @PatientID = [iem].[PatientID]
            AND [iem].[StatusCode] IN (
                                          N'N', N'S', N'C'
                                      )
            AND (
                    [ie].[StatusCode] != N'X'
                    OR [ie].[StatusCode] IS NULL
                ); /* filter canceled encounters */

        UPDATE
            [#Encounter]
        SET
            [TMP_DIAGNOSIS] = ISNULL([Description], N' '),
            [TMP_DIAGID] = ISNULL([DiagnosisCodeID], 0)
        FROM
            [#Encounter]             AS [ie]
            INNER JOIN
                [Intesys].[Diagnosis] AS [id]
                    ON [ie].[TMP_ENCID] = [id].[EncounterID]
        WHERE
            [id].[InactiveSwitch] IS NULL
            AND [id].[SequenceNumber] =
                (
                    SELECT
                        MAX([id1].[SequenceNumber])
                    FROM
                        [#Encounter]             AS [ie]
                        INNER JOIN
                            [Intesys].[Diagnosis] AS [id1]
                                ON [ie].[TMP_ENCID] = [id1].[EncounterID]
                    WHERE
                        [id1].[InactiveSwitch] IS NULL
                );

        --Update each of the records in the temporary table that have an account number and have not been moved or merged
        UPDATE
            [#Encounter]
        SET
            [TMP_ACCT_XID] = [AccountXID]
        FROM
            [#Encounter]
            INNER JOIN
                [Intesys].[Encounter]
                    ON [TMP_ENCID] = [ie].[EncounterID]
            INNER JOIN
                [Intesys].[Account]
                    ON [ie].[AccountID] = [Account].[AccountID]
        WHERE
            [ie].[PatientID] = @PatientID
            AND [AccountXID] IS NOT NULL
            AND [TMP_ENC_MAP_StatusCode] != N'N';

        --update each of the records in the temporary table that do not have an account number and have not been moved or merged
        UPDATE
            [#Encounter]
        SET
            [TMP_ACCT_XID] = '*NOT AVAILABLE*'
        FROM
            [#Encounter]
        WHERE
            [TMP_ACCT_XID] = @AccountNumber
            AND /* SEE DETAIL */ [TMP_ENC_MAP_StatusCode] != N'N'
            AND [TMP_ENC_MAP_StatusCode] != N'S';

        UPDATE
            [#Encounter]
        SET
            [TMP_DIAGNOSIS] = [ShortDescription]
        FROM
            [#Encounter]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [TMP_DIAGID] = [imc].[CodeID]
        WHERE
            [TMP_DIAGID] != 0;

        --Retrieve patient class and Type from misc_code; ignore if ShortDescription is NULL
        UPDATE
            [#Encounter]
        SET
            [TMP_PAT_TYPE] = ISNULL([M].[ShortDescription], N''),
            [TMP_PAT_CLASS] = ISNULL([M2].[ShortDescription], N'')
        FROM
            [#Encounter]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode] AS [M]
                    ON ([TMP_PAT_TYPEID] = [M].[CodeID])
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [M2]
                    ON [TMP_PAT_CLASSID] = [M2].[CodeID];

        --Retrieve medical service from misc_code; ignore if ShortDescription is NULL
        UPDATE
            [#Encounter]
        SET
            [TMP_MED_SRVC] = [ShortDescription]
        FROM
            [#Encounter]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [TMP_MED_SRVCID] = [imc].[CodeID]
        WHERE
            [imc].[ShortDescription] IS NOT NULL;

        UPDATE
            [#Encounter]
        SET
            [TMP_DEPT_CODE] = [OrganizationCode]
        FROM
            [Intesys].[Organization]
        WHERE
            [TMP_DEPTID] = [int_organization].[OrganizationID];

        --Data has been built now select out all data
        SELECT
            [TMP_ACCT_XID],
            [TMP_ENCID],
            [TMP_ACCTID],
            [TMP_PAT_TYPE],
            [TMP_AdmitDateTime],
            [TMP_DISCHDateTime],
            [TMP_MED_SRVC],
            [TMP_DIAGNOSIS],
            [TMP_ENC_StatusCode],
            [TMP_DRID],
            [TMP_DR_LAST_NAME],
            [TMP_DR_FIRST_NAME],
            [TMP_DR_MIDDLE_NAME],
            [TMP_ENC_MAP_StatusCode],
            [TMP_ENC_XID],
            [TMP_STAT_ACT_CODE],
            [TMP_PAT_CLASS],
            [TMP_VIPSwitch],
            [TMP_DEPT_CODE],
            [TMP_DEPTID],
            [TMP_ROOM],
            [TMP_BED],
            [TMP_DISPOCodeID]
        FROM
            [#Encounter]
        ORDER BY
            [TMP_AdmitDateTime] DESC;

        DROP TABLE [#Encounter];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEncountersDetails';

