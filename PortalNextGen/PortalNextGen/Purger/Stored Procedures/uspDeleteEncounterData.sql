CREATE PROCEDURE [Purger].[uspDeleteEncounterData]
    (
        @ChunkSize           INT,
        @EncounterDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;

        SET @EncounterDataPurged = 0; -- Initialize to remove code analysis warning.

        -- Delete Encounter first as the root, then delete other leaves
        DELETE
        [iem]
        FROM
            [Intesys].[EncounterMap] AS [iem]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [id]
        FROM
            [Intesys].[Diagnosis] AS [id]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [idd]
        FROM
            [Intesys].[DiagnosisRelatedGroup] AS [idd]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ig]
        FROM
            [Archive].[Guarantor] AS [ig]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [io]
        FROM
            [Intesys].[Order] AS [io]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [iom]
        FROM
            [Intesys].[OrderMap] AS [iom]
        WHERE
            [OrderID] NOT IN (
                                 SELECT
                                     [OrderID]
                                 FROM
                                     [Intesys].[Order]
                             );

        SET @RC += @@ROWCOUNT;

        DELETE
        [iol]
        FROM
            [Intesys].[OrderLine] AS [iol]
        WHERE
            [OrderID] NOT IN (
                                 SELECT
                                     [OrderID]
                                 FROM
                                     [Intesys].[Order]
                             );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ipld]
        FROM
            [Intesys].[PatientListDetail] AS [ipld]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [iethi]
        FROM
            [Intesys].[EncounterToDiagnosisHealthCareProviderInt] AS [iethi]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ieth]
        FROM
            [Intesys].[EncounterTransferHistory] AS [ieth]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ipm]
        FROM
            [Intesys].[PatientMonitor] AS [ipm]
        WHERE
            [EncounterID] NOT IN (
                                     SELECT
                                         [EncounterID]
                                     FROM
                                         [Intesys].[Encounter]
                                 )
            AND ISNULL([ipm].[ActiveSwitch], 0) <> 1;

        SET @RC += @@ROWCOUNT;

        DELETE
        [ia]
        FROM
            [Intesys].[Account] AS [ia]
        WHERE
            [AccountID] NOT IN (
                                   SELECT
                                       [AccountID]
                                   FROM
                                       [Intesys].[Encounter]
                               );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ip]
        FROM
            [Intesys].[Person] AS [ip]
        WHERE
            [ip].[PersonID] IN (
                                   SELECT
                                       [PatientID]
                                   FROM
                                       [old].[vwPatientDaysSinceLastDischarge]
                                   WHERE
                                       [DaysSinceLastDischarge] >= 10
                               );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ip]
        FROM
            [Intesys].[Patient] AS [ip]
        WHERE
            [PatientID] IN (
                               SELECT
                                   [PatientID]
                               FROM
                                   [old].[vwPatientDaysSinceLastDischarge]
                               WHERE
                                   [DaysSinceLastDischarge] >= 10
                           );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ipn]
        FROM
            [Intesys].[PersonName] AS [ipn]
        WHERE
            [ipn].[PersonNameID] IN (
                                        SELECT
                                            [PatientID]
                                        FROM
                                            [old].[vwPatientDaysSinceLastDischarge]
                                        WHERE
                                            [DaysSinceLastDischarge] >= 10
                                    );

        SET @RC += @@ROWCOUNT;

        DELETE
        [imm]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
        WHERE
            [PatientID] IN (
                               SELECT
                                   [PatientID]
                               FROM
                                   [old].[vwPatientDaysSinceLastDischarge]
                               WHERE
                                   [DaysSinceLastDischarge] >= 10
                           );

        SET @RC += @@ROWCOUNT;

        DELETE
        [ie]
        FROM
            [Intesys].[Encounter] AS [ie]
        WHERE
            [EncounterID] IN (
                                 SELECT
                                     [EncounterID]
                                 FROM
                                     [Intesys].[Encounter]
                                 WHERE
                                     [PatientID] IN (
                                                        SELECT
                                                            [PatientID]
                                                        FROM
                                                            [old].[vwPatientDaysSinceLastDischarge]
                                                        WHERE
                                                            [DaysSinceLastDischarge] >= 10
                                                    )
                             );

        SET @RC += @@ROWCOUNT;

        -- Delete those rows which have a [MonitorCreated] value that is NULL and use the [ModifiedDateTime] instead
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ie]
                FROM
                    [Intesys].[Encounter] AS [ie]
                WHERE
                    [ie].[MonitorCreated] IS NULL -- Generally created by Admit, Discharge, Transfer (ADT)
                    AND DATEDIFF(DAY, [ie].[ModifiedDateTime], SYSUTCDATETIME()) > 30; -- delete records that were never admitted to a device which are older than 30 days

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @EncounterDataPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge encounter data which is no longer needed or allowed by licensing.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteEncounterData';

