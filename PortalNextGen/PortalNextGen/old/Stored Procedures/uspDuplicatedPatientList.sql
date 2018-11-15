CREATE PROCEDURE [old].[uspDuplicatedPatientList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [DUP].[MonitorLoaderDuplicateInformationID],
            [DUP].[DuplicateID] AS [MedicalRecordNumber],
            [imm].[PatientID]
        INTO
            [#Duplicate1]
        FROM
            [old].[MonitorLoaderDuplicateInformation] AS [DUP]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap]    AS [imm]
                    ON [DUP].[DuplicateID] = [imm].[MedicalRecordNumberXID]
            INNER JOIN
                [Intesys].[PatientMonitor]            AS [mon]
                    ON [imm].[PatientID] = [mon].[PatientID]
        WHERE
            [mon].[ActiveSwitch] = 1;

        SELECT
            [DUP].[MonitorLoaderDuplicateInformationID],
            [DUP].[OriginalID] AS [MedicalRecordNumber],
            [imm].[PatientID]
        INTO
            [#Duplicate2]
        FROM
            [old].[MonitorLoaderDuplicateInformation] AS [DUP]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap]    AS [imm]
                    ON [DUP].[OriginalID] = [imm].[MedicalRecordNumberXID]
            INNER JOIN
                [Intesys].[PatientMonitor]            AS [mon]
                    ON [imm].[PatientID] = [mon].[PatientID]
        WHERE
            [mon].[ActiveSwitch] = 1;

        SELECT DISTINCT
            [MAP].[PatientID] AS [PATID],
            [MAP].[MedicalRecordNumberXID]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [MAP]
            INNER JOIN
                [Intesys].[PatientMonitor]     AS [mon]
                    ON [MAP].[PatientID] = [mon].[PatientID]
        WHERE
            [MAP].[MedicalRecordNumberXID] IN (
                                                  SELECT
                                                      [DUP].[OriginalID]
                                                  FROM
                                                      [old].[MonitorLoaderDuplicateInformation] AS [DUP]
                                                  WHERE
                                                      [DUP].[MonitorLoaderDuplicateInformationID] IN (
                                                                                                         SELECT
                                                                                                             [#Duplicate1].[MonitorLoaderDuplicateInformationID]
                                                                                                         FROM
                                                                                                             [#Duplicate1]
                                                                                                             INNER JOIN
                                                                                                                 [#Duplicate2]
                                                                                                                     ON [#Duplicate1].[MonitorLoaderDuplicateInformationID] = [#Duplicate2].[MonitorLoaderDuplicateInformationID]
                                                                                                     )
                                              )
            OR [MAP].[MedicalRecordNumberXID] IN (
                                                     SELECT
                                                         [DUP].[DuplicateID]
                                                     FROM
                                                         [old].[MonitorLoaderDuplicateInformation] AS [DUP]
                                                     WHERE
                                                         [DUP].[MonitorLoaderDuplicateInformationID] IN (
                                                                                                            SELECT
                                                                                                                [#Duplicate1].[MonitorLoaderDuplicateInformationID]
                                                                                                            FROM
                                                                                                                [#Duplicate1]
                                                                                                                INNER JOIN
                                                                                                                    [#Duplicate2]
                                                                                                                        ON [#Duplicate1].[MonitorLoaderDuplicateInformationID] = [#Duplicate2].[MonitorLoaderDuplicateInformationID]
                                                                                                        )
                                                 )
               AND [mon].[ActiveSwitch] = 1;

        DROP TABLE [#Duplicate1];

        DROP TABLE [#Duplicate2];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDuplicatedPatientList';

