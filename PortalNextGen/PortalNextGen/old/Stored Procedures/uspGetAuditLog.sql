CREATE PROCEDURE [old].[uspGetAuditLog]
    (
        @FromDate DATETIME2(7),
        @ToDate   DATETIME2(7),
        @Filters  NVARCHAR(MAX),
        @Debug    BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery NVARCHAR(MAX);

        SET @SqlQuery
            = '
SELECT 
    ISNULL(int_audit_log.LoginID, '''') AS [Login ID],
    int_audit_log.ApplicationID AS [Application], 
    int_audit_log.DeviceName AS [Location], 
    int_audit_log.AuditDateTime], 
    int_MedicalRecordNumbermap.MedicalRecordNumberXID AS [Patient ID],
    int_misc_code.ShortDescription AS [Event], 
    int_audit_log.AuditDescription AS [Description] 
FROM dbo.int_audit_log 
    LEFT OUTER JOIN dbo.int_MedicalRecordNumbermap 
        ON int_audit_log.PatientID = int_MedicalRecordNumbermap.MedicalRecordNumberXID 
    INNER JOIN dbo.int_misc_code 
        ON int_misc_code.code = int_audit_log.AuditType
WHERE audit_dt BETWEEN ';

        SET @SqlQuery += '''' + CAST(@FromDate AS VARCHAR(30)) + '''';
        SET @SqlQuery += ' AND ';
        SET @SqlQuery += '''' + CAST(@ToDate AS VARCHAR(30)) + '''';

        IF (LEN(@Filters) > 0)
            SET @SqlQuery += ' AND ';

        SET @SqlQuery += @Filters;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery); -- TG-Why not use sp_executesql??
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetAuditLog';

