CREATE PROCEDURE [dbo].[usp_Get_AuditLogDefault]
AS
BEGIN
    SELECT
        ISNULL([int_audit_log].[login_id], '') AS [Login ID],
        [int_audit_log].[application_id] AS [Application],
        [int_audit_log].[device_name] AS [Location],
        [int_audit_log].[audit_dt] AS [Date],
        [int_mrn_map].[mrn_xid] AS [Patient ID],
        [int_misc_code].[short_dsc] AS [Event],
        [int_audit_log].[audit_descr] AS [Description]
    FROM
        [dbo].[int_audit_log]
        LEFT OUTER JOIN [dbo].[int_mrn_map] ON [int_audit_log].[patient_id] = [int_mrn_map].[mrn_xid]
        INNER JOIN [dbo].[int_misc_code] ON [int_misc_code].[code] = [int_audit_log].[audit_type];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_Get_AuditLogDefault';

