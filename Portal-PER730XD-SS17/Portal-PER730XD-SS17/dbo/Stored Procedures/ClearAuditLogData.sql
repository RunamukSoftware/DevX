CREATE PROCEDURE [dbo].[ClearAuditLogData]
    (
     @PatientId [dbo].[DPATIENT_ID]
    )
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [dbo].[AuditLogData]
    WHERE
        [PatientID] = @PatientId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'ClearAuditLogData';

