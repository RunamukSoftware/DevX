CREATE PROCEDURE [Purger].[uspPurgePatientByMedicalRecordNumber] (@MedicalRecordNumber CHAR(30))
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @PatientID INT,
            @Message   VARCHAR(120);

        SELECT
            @PatientID = [imm].[PatientID]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
        WHERE
            [imm].[MedicalRecordNumberXID] = @MedicalRecordNumber;

        IF (@PatientID IS NULL)
            SELECT
                'patient not found..';
        ELSE
            BEGIN
                SET @Message
                    = 'Purging patient: MRN=' + @MedicalRecordNumber + ' PatientID = '
                      + CAST(@PatientID AS VARCHAR(20));

                SELECT
                    @Message;

                DELETE
                [ip]
                FROM
                    [Intesys].[Patient] AS [ip]
                WHERE
                    [ip].[PatientID] = @PatientID;

                DELETE
                [ipn]
                FROM
                    [Intesys].[PersonName] AS [ipn]
                WHERE
                    [ipn].[PersonNameID] = @PatientID;

                DELETE
                [ip]
                FROM
                    [Intesys].[Person] AS [ip]
                WHERE
                    [ip].[PersonID] = @PatientID;

                DELETE
                [ie]
                FROM
                    [Intesys].[Encounter] AS [ie]
                WHERE
                    [ie].[PatientID] = @PatientID;

                DELETE
                [ir]
                FROM
                    [Intesys].[Result] AS [ir]
                WHERE
                    [ir].[PatientID] = @PatientID;

                DELETE
                [imm]
                FROM
                    [Intesys].[MedicalRecordNumberMap] AS [imm]
                WHERE
                    [imm].[PatientID] = @PatientID;

                DELETE
                [iem]
                FROM
                    [Intesys].[EncounterMap] AS [iem]
                WHERE
                    [iem].[PatientID] = @PatientID;

                DELETE
                [iom]
                FROM
                    [Intesys].[OrderMap] AS [iom]
                WHERE
                    [iom].[PatientID] = @PatientID;

                DELETE
                [iol]
                FROM
                    [Intesys].[OrderLine] AS [iol]
                WHERE
                    [iol].[PatientID] = @PatientID;

                DELETE
                [io]
                FROM
                    [Intesys].[Order] AS [io]
                WHERE
                    [io].[PatientID] = @PatientID;
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspPurgePatientByMedicalRecordNumber';

