CREATE PROCEDURE [old].[uspGetAuditLogDefault]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            ISNULL([ial].[LoginID], N'')   AS [LoginID],
            [ial].[ApplicationID]          AS [Application],
            [ial].[DeviceName]             AS [Location],
            [ial].[AuditDateTime],
            [imm].[MedicalRecordNumberXID] AS [PatientID],
            [imc].[ShortDescription]       AS [Event],
            [ial].[AuditDescription]       AS [Description]
        FROM
            [Intesys].[AuditLog]                   AS [ial]
            LEFT OUTER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ial].[PatientID] = [imm].[MedicalRecordNumberXID]
            INNER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [imc].[Code] = [ial].[AuditType];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetAuditLogDefault';

