CREATE PROCEDURE [HL7].[uspGetAttendingHealthCareProviderData] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [hcpMap].[HealthCareProviderXID] AS [hcpID],
            [hcp].[LastName]   AS [hcpLastName],
            [hcp].[FirstName]  AS [hcpFirstName],
            [hcp].[MiddleName] AS [hcpMiddleName]
        FROM
            [Intesys].[HealthCareProvider]        AS [hcp]
            INNER JOIN
                [Intesys].[HealthCareProviderMap] AS [hcpMap]
                    ON [hcp].[HealthCareProviderID] = [hcpMap].[HealthCareProviderID]
            INNER JOIN
                [Intesys].[Encounter]             AS [enc]
                    ON [enc].[AttendHealthCareProviderID] = [hcp].[HealthCareProviderID]
            INNER JOIN
                [Intesys].[EncounterMap]          AS [encMap]
                    ON [enc].[EncounterID] = [encMap].[EncounterID]
        WHERE
            [enc].[PatientID] = @PatientID
            AND [encMap].[SequenceNumber] = 1
            AND [encMap].[StatusCode] = N'C';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get attending HCP data.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetAttendingHealthCareProviderData';

