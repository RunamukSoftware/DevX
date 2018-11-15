CREATE PROCEDURE [old].[uspGetVisits] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ie].[AdmitDateTime]                                                                                       AS [Admitted],
            [ie].[DischargeDateTime]                                                                                   AS [Discharged],
            [ie].[AccountID]                                                                                           AS [Account Number],
            ISNULL([io].[OrganizationCode], N'-') + N' ' + ISNULL([ie].[Room], N'-') + N' ' + ISNULL([ie].[Bed], N'-') AS [Location],
            [iem].[EncounterXID]                                                                                       AS [Encounter Number],
            [ie].[EncounterID]                                                                                         AS [GUID]
        FROM
            [Intesys].[Encounter]        AS [ie]
            INNER JOIN
                [Intesys].[EncounterMap] AS [iem]
                    ON [ie].[EncounterID] = [iem].[EncounterID]
            INNER JOIN
                [Intesys].[Organization] AS [io]
                    ON [ie].[UnitOrganizationID] = [io].[OrganizationID]
        WHERE
            [ie].[PatientID] = @PatientID
        ORDER BY
            [ie].[AdmitDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetVisits';

