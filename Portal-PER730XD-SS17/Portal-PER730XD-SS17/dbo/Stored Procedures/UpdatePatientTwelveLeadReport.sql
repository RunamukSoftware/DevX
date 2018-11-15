CREATE PROCEDURE [dbo].[UpdatePatientTwelveLeadReport]
    (
     @report_id UNIQUEIDENTIFIER,
     @Interpretation VARCHAR(256)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_12lead_report_new]
    SET
        [interpretation] = @Interpretation
    WHERE
        ([report_id] = @report_id);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'UpdatePatientTwelveLeadReport';

