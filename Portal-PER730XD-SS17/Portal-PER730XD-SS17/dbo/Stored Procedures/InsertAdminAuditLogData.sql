CREATE PROCEDURE [dbo].[InsertAdminAuditLogData]
    (
     @login_id NVARCHAR(256),
     @application_id NVARCHAR(50),
     @patient_id NVARCHAR(50),
     @audit_type NVARCHAR(160),
     @device_name NVARCHAR(64),
     @audit_descr NVARCHAR(500)
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[int_audit_log]
            ([login_id],
             [application_id],
             [patient_id],
             [audit_type],
             [device_name],
             [audit_descr],
             [audit_dt]
            )
    VALUES
            (@login_id,
             @application_id,
             @patient_id,
             @audit_type,
             @device_name,
             @audit_descr,
             GETDATE()
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by ICS Admin to log information to audit log.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'InsertAdminAuditLogData';

