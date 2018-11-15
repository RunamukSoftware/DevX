CREATE PROCEDURE [old].[uspClearAuditLogData] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [old].[AuditLog]
        WHERE
            [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspClearAuditLogData';

