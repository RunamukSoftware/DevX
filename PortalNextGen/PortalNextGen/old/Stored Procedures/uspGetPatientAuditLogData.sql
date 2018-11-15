CREATE PROCEDURE [old].[uspGetPatientAuditLogData] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [al].[AuditID],
            [al].[AuditDateTime],
            [al].[PatientID],
            [al].[Application],
            [al].[DeviceName],
            [al].[Message],
            [al].[ItemName],
            [al].[OriginalValue],
            [al].[NewValue],
            [al].[HashedValue],
            [al].[ChangedBy]
        FROM
            [old].[AuditLog] AS [al]
        WHERE
            [al].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientAuditLogData';

