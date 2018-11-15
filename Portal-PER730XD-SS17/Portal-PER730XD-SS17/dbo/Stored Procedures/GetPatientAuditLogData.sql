CREATE PROCEDURE [dbo].[GetPatientAuditLogData]
    (
     @PatientId [dbo].[DPATIENT_ID]
    )
AS
BEGIN
    SELECT
        [AuditId],
        [DateTime],
        [PatientID],
        [Application],
        [DeviceName],
        [Message],
        [ItemName],
        [OriginalValue],
        [NewValue],
        [HashedValue],
        [ChangedBy]
    FROM
        [dbo].[AuditLogData]
    WHERE
        [PatientID] = @PatientId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientAuditLogData';

