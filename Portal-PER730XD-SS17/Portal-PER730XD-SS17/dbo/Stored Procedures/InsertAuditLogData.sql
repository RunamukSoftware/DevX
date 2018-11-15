CREATE PROCEDURE [dbo].[InsertAuditLogData]
    (
     @AuditId VARCHAR(64),
     @PatientId VARCHAR(256),
     @Application VARCHAR(256),
     @DeviceName VARCHAR(256),
     @Message VARCHAR(MAX), -- TG - should be NVARCHAR(MAX)
     @ItemName VARCHAR(256),
     @OriginalValue VARCHAR(MAX), -- TG - should be NVARCHAR(MAX)
     @NewValue VARCHAR(MAX), -- TG - should be NVARCHAR(MAX)
     @ChangedBy VARCHAR(64),
     @HashedValue BINARY(20)
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[AuditLogData]
            ([AuditId],
             [DateTime],
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
            (CAST(@AuditId AS UNIQUEIDENTIFIER),
             GETDATE(),
             @PatientId,
             @Application,
             @DeviceName,
             CAST(@Message AS NVARCHAR(MAX)),
             @ItemName,
             CAST(@OriginalValue AS NVARCHAR(MAX)),
             CAST(@NewValue AS NVARCHAR(MAX)),
             @ChangedBy,
             @HashedValue
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert information into the AuditLogData table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'InsertAuditLogData';

