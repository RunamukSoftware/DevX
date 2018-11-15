CREATE PROCEDURE [dbo].[DeletePatientTwelveLeadReport]
    (
     @report_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE FROM
        [dbo].[int_12lead_report]
    WHERE
        ([report_id] = @report_id);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeletePatientTwelveLeadReport';

