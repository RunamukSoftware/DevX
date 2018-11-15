CREATE PROCEDURE [old].[uspEncounterDetail]
    (
        @PatientID       INT,
        @StrNotAvailable VARCHAR(100)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @AccountNumber CHAR(40)     = 'SEE DETAIL',
            @Diagnosis     VARCHAR(255) = ' ',
            @PatientType   VARCHAR(30)  = '',
            @PatientClass  VARCHAR(30)  = '';

        SELECT DISTINCT
            @AccountNumber                   AS [TMP_ACCT_XID],
            [a].[AccountID]                  AS [TMP_ACCTID],
            [a].[EncounterID]                AS [TMP_ENCID],
            [C].[EncounterXID]               AS [TMP_ENC_XID],
            [a].[PatientTypeCodeID]          AS [TMP_PAT_TYPEID],
            @PatientType                     AS [TMP_PAT_TYPE],
            [a].[PatientClassCodeID]         AS [TMP_PAT_CLASSID],
            @PatientClass                    AS [TMP_PAT_CLASS],
            [a].[AdmitDateTime]              AS [TMP_AdmitDateTime],
            [a].[DischargeDateTime]          AS [TMP_DischargeDateTime],
            [a].[MedicalServiceCodeID]       AS [TMP_MED_SRVCID],
            SPACE(20)                        AS [TMP_MED_SRVC],
            0                                AS [TMP_DIAGID],
            @Diagnosis                       AS [TMP_DIAGNOSIS],
            [a].[AttendHealthCareProviderID] AS [TMP_DRID],
            [a].[StatusCode]                 AS [TMP_ENC_StatusCode],
            [B].[LastName]                   AS [TMP_DR_LAST_NAME],
            [B].[FirstName]                  AS [TMP_DR_FIRST_NAME],
            [B].[MiddleName]                 AS [TMP_DR_MIDDLE_NAME],
            [C].[StatusCode]                 AS [TMP_ENC_MAP_StatusCode],
            [C].[EventCode]                  AS [TMP_STAT_ACT_CODE],
            [a].[VipSwitch]                  AS [TMP_VIPSwitch],
            SPACE(20)                        AS [TMP_DEPT_CODE],
            [a].[UnitOrganizationID]         AS [TMP_DEPTID],
            [a].[Room]                       AS [TMP_ROOM],
            [a].[Bed]                        AS [TMP_BED],
            [a].[DischargeDispositionCodeID] AS [TMP_DISPOCodeID]
        INTO
            [#Encounter]
        FROM
            [Intesys].[Encounter]              AS [a]
            LEFT OUTER JOIN
                [Intesys].[HealthCareProvider] AS [B]
                    ON [a].[AttendHealthCareProviderID] = [B].[HealthCareProviderID]
            INNER JOIN
                [Intesys].[EncounterMap]       AS [C]
                    ON [a].[EncounterID] = [C].[EncounterID]
        WHERE
            @PatientID = [C].[PatientID]
            AND [C].[StatusCode] IN (
                                        N'N', N'S', N'C'
                                    )
            AND (
                    [a].[StatusCode] != N'X'
                    OR [a].[StatusCode] IS NULL
                );

        --filter canceled encounters
        UPDATE
            [#Encounter]
        SET
            [TMP_DIAGNOSIS] = ISNULL([Description], N' '),
            [TMP_DIAGID] = ISNULL([DiagnosisCodeID], 0)
        FROM
            [#Encounter]              AS [a]
            INNER JOIN
                [Intesys].[Diagnosis] AS [B]
                    ON [a].[TMP_ENCID] = [B].[EncounterID]
        WHERE
            [B].[InactiveSwitch] IS NULL
            AND [B].[SequenceNumber] =
                (
                    SELECT
                        MAX([B].[SequenceNumber])
                    FROM
                        [#Encounter]              AS [a]
                        INNER JOIN
                            [Intesys].[Diagnosis] AS [B]
                                ON [a].[TMP_ENCID] = [B].[EncounterID]
                    WHERE
                        [B].[InactiveSwitch] IS NULL
                );

        --UPDATE each of the records in the temporary table that have an account number and have not been moved or merged
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
            [AccountXID] IS NOT NULL
            AND [TMP_ENC_MAP_StatusCode] != N'N'
            AND [ie].[PatientID] = @PatientID;

        --update each of the records in the temporary table that do not have an account number and have not been moved or merged
        UPDATE
            [#Encounter]
        SET
            [TMP_ACCT_XID] = @StrNotAvailable
        FROM
            [#Encounter]
        WHERE
            [TMP_ACCT_XID] = @AccountNumber --SEE DETAIL
            AND [TMP_ENC_MAP_StatusCode] != N'N'
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

        --Retrieve patient class and Type from misc_code; ShortDescription is NULL
        UPDATE
            [#Encounter]
        SET
            [TMP_PAT_TYPE] = ISNULL([M].[ShortDescription], ''),
            [TMP_PAT_CLASS] = ISNULL([M2].[ShortDescription], '')
        FROM
            [#Encounter]                      AS [e]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode] AS [M]
                    ON [e].[TMP_PAT_TYPEID] = [M].[CodeID]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [M2]
                    ON [e].[TMP_PAT_CLASSID] = [M2].[CodeID];

        --Retrieve medical service from misc_code; ignore if ShortDescription is NULL
        UPDATE
            [#Encounter]
        SET
            [TMP_MED_SRVC] = [ShortDescription]
        FROM
            [#Encounter]                      AS [e]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [e].[TMP_MED_SRVCID] = [imc].[CodeID]
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

        --data has been built now select out all data
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEncounterDetail';

