CREATE PROCEDURE [dbo].[usp_GetVisits]
    (
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [int_encounter].[admit_dt] AS [Admitted],
        [int_encounter].[discharge_dt] AS [Discharged],
        [int_encounter].[account_id] AS [Account Number],
        ISNULL([int_organization].[organization_cd], '-') + ' ' + ISNULL([int_encounter].[rm], N'-') + N' ' + ISNULL([int_encounter].[bed], N'-') AS [Location],
        [int_encounter_map].[encounter_xid] AS [Encounter Number],
        [int_encounter].[encounter_id] AS [GUID]
    FROM
        [dbo].[int_encounter]
        INNER JOIN [dbo].[int_encounter_map] ON [int_encounter].[encounter_id] = [int_encounter_map].[encounter_id]
        INNER JOIN [dbo].[int_organization] ON [int_encounter].[unit_org_id] = [int_organization].[organization_id]
    WHERE
        [int_encounter].[patient_id] = @PatientId
    ORDER BY
        [int_encounter].[admit_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetVisits';

