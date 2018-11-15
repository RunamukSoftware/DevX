CREATE PROCEDURE [dbo].[GetTwelveLeadReports]
AS
BEGIN
    DECLARE @PurgeHours NVARCHAR(80); /* Purge hours set by ICS admin */
    DECLARE @outDate INT;             /* Numeric hours */
    DECLARE @PurgeDate DATETIME;      /* Valid start time */ 

    BEGIN TRY
        SET @PurgeHours = (SELECT TOP (1)
                            [parm_value]
                           FROM
                            [dbo].[int_system_parameter]
                           WHERE
                            [name] = N'TwelveLead'
                          );
        SET @outDate = CASE WHEN ISNUMERIC(@PurgeHours) = 1 THEN CAST(@PurgeHours AS INT)
                            ELSE 168        /* Default value 168 hrs*/
                       END;     
        SET @PurgeDate = DATEADD(HOUR, -@outDate, GETDATE()); /* Set the valid start time */
    END TRY
    BEGIN CATCH 
        SET @PurgeDate = DATEADD(HOUR, -168, GETDATE()); /* Set the valid start time -168 hrs */
    END CATCH;
    
    SELECT
        [mrn_xid] AS [PATIENTID],
        [mrn_xid2] AS [SECONDARYPATIENTID],
        [ssn],
        [GEN].[short_dsc] AS [GENDER],
        [first_nm],
        [last_nm],
        [int_monitor].[monitor_name] AS [BED],
        [int_monitor].[node_id],
        [int_12lead_report].[report_data],
        [int_12lead_report].[report_id],
        [DEPT].[organization_nm] AS [DEPARTMENTNAME],
        [DEPT].[organization_id] AS [DEPARTMENTID],
        [DEPT].[category_cd] AS [DEPARTMENTCATEGORY],
        [DEPT].[organization_cd] AS [DEPARTMENTORGCATEGORY],
        [FACIL].[organization_nm] AS [FACILITYNAME],
        [FACIL].[organization_id] AS [FACILITYID],
        [FACIL].[category_cd] AS [FACILITYCATEGORY],
        [FACIL].[organization_cd] AS [FACILITYORGCATEGORY],
        [ORG].[organization_nm] AS [ORGANIZATIONNAME],
        [ORG].[organization_id] AS [ORGANIZATIONID],
        [ORG].[category_cd] AS [ORGANIZATIONCATEGORY],
        [ORG].[organization_cd] AS [ORGANIZATIONORGCATEGORY]
    FROM
        [dbo].[int_patient]
        INNER JOIN [dbo].[int_mrn_map] ON [dbo].[int_patient].[patient_id] = [dbo].[int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_person] ON [dbo].[int_person].[person_id] = [dbo].[int_patient].[patient_id]
        INNER JOIN [dbo].[int_12lead_report] ON [dbo].[int_12lead_report].[patient_id] = [dbo].[int_person].[person_id]
        INNER JOIN [dbo].[int_monitor] ON [int_12lead_report].[monitor_id] = [int_monitor].[monitor_id]
        INNER JOIN [dbo].[int_organization] AS [DEPT] ON [int_monitor].[unit_org_id] = [DEPT].[organization_id]
        INNER JOIN [dbo].[int_organization] AS [FACIL] ON [DEPT].[parent_organization_id] = [FACIL].[organization_id]
        INNER JOIN [dbo].[int_organization] AS [ORG] ON [FACIL].[parent_organization_id] = [ORG].[organization_id]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [GEN] ON [dbo].[int_patient].[gender_cid] = [GEN].[code_id]
    WHERE
        [int_mrn_map].[orig_patient_id] IS NULL
        AND [report_dt] > @PurgeDate
        AND ([int_12lead_report].[export_sw] <> 1
        OR [int_12lead_report].[export_sw] IS NULL
        );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetTwelveLeadReports';

