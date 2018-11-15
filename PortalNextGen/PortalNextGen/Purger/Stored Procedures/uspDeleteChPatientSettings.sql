CREATE PROCEDURE [Purger].[uspDeleteChPatientSettings]
    (
        @ChunkSize                 INT,
        @PurgeDate                 DATETIME2(7),
        @PatientSettingsDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [cvp]
                FROM
                    [Configuration].[ValuePatient] AS [cvp]
                WHERE
                    [cvp].[Timestamp] < @PurgeDate
                    AND [PatientID] NOT IN (
                                               SELECT
                                                   [PatientID]
                                               FROM
                                                   [Intesys].[Encounter]
                                               WHERE
                                                   [DischargeDateTime] IS NULL
                                           );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @PatientSettingsDataPurged = @@ROWCOUNT;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CH Patient Settings purge', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteChPatientSettings';

