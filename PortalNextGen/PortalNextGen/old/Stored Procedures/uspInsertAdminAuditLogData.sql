CREATE PROCEDURE [old].[uspInsertAdminAuditLogData]
    (
        @LoginID          INT,
        @ApplicationID    INT,
        @PatientID        INT,
        @AuditType        NVARCHAR(160),
        @DeviceName       NVARCHAR(64),
        @AuditDescription NVARCHAR(500)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[AuditLog]
            (
                [LoginID],
                [ApplicationID],
                [PatientID],
                [AuditType],
                [DeviceName],
                [AuditDescription],
                [AuditDateTime]
            )
        VALUES
            (
                @LoginID, @ApplicationID, @PatientID, @AuditType, @DeviceName, @AuditDescription, SYSUTCDATETIME()
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by ICS Admin to log information to audit log.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertAdminAuditLogData';

