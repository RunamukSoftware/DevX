CREATE PROCEDURE [old].[uspInsertAuditLogData]
    (
        @AuditID       INT,
        @PatientID     INT,
        @Application   VARCHAR(256),
        @DeviceName    VARCHAR(256),
        @Message       NVARCHAR(MAX),
        @ItemName      VARCHAR(256),
        @OriginalValue NVARCHAR(MAX),
        @NewValue      NVARCHAR(MAX),
        @ChangedBy     VARCHAR(64),
        @HashedValue   BINARY(20)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[AuditLog]
            (
                [AuditID],
                [AuditDateTime],
                [PatientID],
                [Application],
                [DeviceName],
                [Message],
                [ItemName],
                [OriginalValue],
                [NewValue],
                [ChangedBy],
                [HashedValue]
            )
        VALUES
            (
                @AuditID,
                SYSUTCDATETIME(),
                @PatientID,
                @Application,
                @DeviceName,
                @Message,
                @ItemName,
                @OriginalValue,
                @NewValue,
                @ChangedBy,
                @HashedValue
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert information into the AuditLogData table.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertAuditLogData';

