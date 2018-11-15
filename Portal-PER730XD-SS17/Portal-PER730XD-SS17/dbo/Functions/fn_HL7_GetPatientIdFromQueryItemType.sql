CREATE FUNCTION [dbo].[fn_HL7_GetPatientIdFromQueryItemType]
    (
     @QueryItem NVARCHAR(80),
     @QueryType INT
    )
RETURNS UNIQUEIDENTIFIER
    WITH SCHEMABINDING
AS
BEGIN
    DECLARE @patient_id UNIQUEIDENTIFIER;

    IF (@QueryType = 0)
    BEGIN
        SELECT
            @patient_id = [PATIENTID]
        FROM
            (SELECT
                [MAP].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[int_mrn_map] AS [MAP]
                INNER JOIN [dbo].[int_patient_monitor] AS [PATMON] ON [PATMON].[patient_id] = [MAP].[patient_id]
                INNER JOIN [dbo].[int_monitor] AS [MONITOR] ON [MONITOR].[monitor_id] = [PATMON].[monitor_id]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [MONITOR].[unit_org_id]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [MONITOR].[unit_org_id]
             WHERE
                [MAP].[mrn_xid] = @QueryItem
                AND [merge_cd] = 'C'
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
             UNION
             SELECT
                [DLPAT].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[v_PatientSessions] AS [DLPAT]
                INNER JOIN [dbo].[int_product_access] AS [Access] ON [Access].[organization_id] = [DLPAT].[UNIT_ID]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [DLPAT].[UNIT_ID]
             WHERE
                [DLPAT].[MRN_ID] = @QueryItem
                AND [Access].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
            ) AS [PATIENTID];
    
    END;

    IF (@QueryType = 1)
    BEGIN
    
        SELECT
            @patient_id = [PATIENTID]
        FROM
            (SELECT
                [MAP].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[int_mrn_map] AS [MAP]
                INNER JOIN [dbo].[int_patient_monitor] AS [PATMON] ON [PATMON].[patient_id] = [MAP].[patient_id]
                INNER JOIN [dbo].[int_monitor] AS [MONITOR] ON [MONITOR].[monitor_id] = [PATMON].[monitor_id]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [MONITOR].[unit_org_id]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [MONITOR].[unit_org_id]
             WHERE
                [MAP].[mrn_xid2] = @QueryItem
                AND [merge_cd] = 'C'
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
             UNION
             SELECT
                [DLPAT].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[v_PatientSessions] AS [DLPAT]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [DLPAT].[UNIT_ID]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [DLPAT].[UNIT_ID]
             WHERE
                [DLPAT].[ACCOUNT_ID] = @QueryItem
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
            ) AS [PATIENTID];
    END;

    IF (@QueryType = 2)
    BEGIN
        SELECT
            @patient_id = [PATIENTID]
        FROM
            (SELECT
                [MAP].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[int_mrn_map] AS [MAP]
                INNER JOIN [dbo].[int_patient_monitor] AS [PATMON] ON [PATMON].[patient_id] = [MAP].[patient_id]
                INNER JOIN [dbo].[int_monitor] AS [MONITOR] ON [MONITOR].[monitor_id] = [PATMON].[monitor_id]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [MONITOR].[unit_org_id]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [MONITOR].[unit_org_id]
             WHERE
                [MONITOR].[node_id] = @QueryItem
                AND [PATMON].[active_sw] = 1
                AND [merge_cd] = 'C'
                AND [ORG].[organization_id] = [MONITOR].[unit_org_id]
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
             UNION
             SELECT
                [DLPAT].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[v_PatientSessions] AS [DLPAT]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [DLPAT].[UNIT_ID]
                INNER JOIN [dbo].[Devices] AS [DEV] ON [DEV].[Id] = [DLPAT].[PATIENT_MONITOR_ID]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [DLPAT].[UNIT_ID]
             WHERE
                [DEV].[Name] = @QueryItem
                AND [STATUS] = 'A'
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
            ) AS [PATIENTID];
    END;

    IF (@QueryType = 3)
    BEGIN
        SELECT
            @patient_id = [PATIENTID]
        FROM
            (SELECT
                [MAP].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[int_mrn_map] AS [MAP]
                INNER JOIN [dbo].[int_patient_monitor] AS [PATMON] ON [PATMON].[patient_id] = [MAP].[patient_id]
                INNER JOIN [dbo].[int_monitor] AS [MONITOR] ON [MONITOR].[monitor_id] = [PATMON].[monitor_id]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [MONITOR].[unit_org_id]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [MONITOR].[unit_org_id]
             WHERE
                [MONITOR].[monitor_name] = @QueryItem
                AND [PATMON].[active_sw] = 1
                AND [merge_cd] = 'C'
                AND [ORG].[organization_id] = [MONITOR].[unit_org_id]
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
             UNION
             SELECT
                [DLPAT].[patient_id] AS [PATIENTID]
             FROM
                [dbo].[v_PatientSessions] AS [DLPAT]
                INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [DLPAT].[UNIT_ID]
                INNER JOIN [dbo].[Devices] AS [DEV] ON [DEV].[Id] = [DLPAT].[DeviceId]
                INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [DLPAT].[UNIT_ID]
             WHERE
                [DLPAT].[BED] = @QueryItem
                AND [STATUS] = 'A'
                AND [ACCESS].[product_cd] = 'outHL7'
                AND [ORG].[category_cd] = 'D'
            ) AS [PATIENTID];
    END;

    RETURN @patient_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'To get the patient details inserted from ADTA01 FOR QRY - HL7 BEGIN - Retrieves the patient Id from given query item type (MRN, ACC, NODE ID or NODE NAME)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'fn_HL7_GetPatientIdFromQueryItemType';

