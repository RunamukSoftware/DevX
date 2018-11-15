CREATE PROCEDURE [old].[uspGetTwelveLeadReports]
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @PurgeHours NVARCHAR(80); /* Purge hours set by ICS admin */
        DECLARE @outDate INT; /* Numeric hours */
        DECLARE @PurgeDate DATETIME2(7); /* Valid start time */

        BEGIN TRY
            SET @PurgeHours =
                (
                    SELECT TOP (1)
                        [isp].[ParameterValue]
                    FROM
                        [Intesys].[SystemParameter] AS [isp]
                    WHERE
                        [isp].[Name] = N'TwelveLead'
                );

            SET @outDate = CASE
                               WHEN ISNUMERIC(@PurgeHours) = 1
                                   THEN CAST(@PurgeHours AS INT)
                               ELSE
                                   168 /* Default value 168 hrs*/
                           END;
            SET @PurgeDate = DATEADD(HOUR, -@outDate, SYSUTCDATETIME()); /* Set the valid start time */
        END TRY
        BEGIN CATCH
            SET @PurgeDate = DATEADD(HOUR, -168, SYSUTCDATETIME()); /* Set the valid start time -168 hrs */
        END CATCH;

        SELECT
            [imm].[MedicalRecordNumberXID]  AS [PatientID],
            [imm].[MedicalRecordNumberXID2] AS [SECONDARYPATIENTID],
            [ipa].[SocialSecurityNumber],
            [imc].[ShortDescription]        AS [GENDER],
            [ipe].[FirstName],
            [ipe].[LastName],
            [im].[MonitorName]              AS [Bed],
            [im].[NodeID],
            [itlr].[ReportData],
            [itlr].[ReportID],
            [DEPT].[OrganizationName]       AS [DEPARTMENTNAME],
            [DEPT].[OrganizationID]         AS [DEPARTMENTID],
            [DEPT].[CategoryCode]           AS [DEPARTMENTCATEGORY],
            [DEPT].[OrganizationCode]       AS [DEPARTMENTORGCATEGORY],
            [FACIL].[OrganizationName]      AS [FACILITYNAME],
            [FACIL].[OrganizationID]        AS [FACILITYID],
            [FACIL].[CategoryCode]          AS [FACILITYCATEGORY],
            [FACIL].[OrganizationCode]      AS [FACILITYORGCATEGORY],
            [ORG].[OrganizationName]        AS [ORGANIZATIONNAME],
            [ORG].[OrganizationID]          AS [ORGANIZATIONID],
            [ORG].[CategoryCode]            AS [ORGANIZATIONCATEGORY],
            [ORG].[OrganizationCode]        AS [ORGANIZATIONORGCATEGORY]
        FROM
            [Intesys].[Patient]                    AS [ipa]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [ipa].[PatientID]
            INNER JOIN
                [Intesys].[TwelveLeadReport]       AS [itlr]
                    ON [itlr].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [itlr].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[Organization]           AS [DEPT]
                    ON [im].[UnitOrganizationID] = [DEPT].[OrganizationID]
            INNER JOIN
                [Intesys].[Organization]           AS [FACIL]
                    ON [DEPT].[ParentOrganizationID] = [FACIL].[OrganizationID]
            INNER JOIN
                [Intesys].[Organization]           AS [ORG]
                    ON [FACIL].[ParentOrganizationID] = [ORG].[OrganizationID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [ipa].[GenderCodeID] = [imc].[CodeID]
        WHERE
            [imm].[OriginalPatientID] IS NULL
            AND [itlr].[ReportDateTime] > @PurgeDate
            AND (
                    [itlr].[ExportSwitch] <> 1
                    OR [itlr].[ExportSwitch] IS NULL
                );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetTwelveLeadReports';

