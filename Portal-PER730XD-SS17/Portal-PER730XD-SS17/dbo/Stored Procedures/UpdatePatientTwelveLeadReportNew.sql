CREATE PROCEDURE [dbo].[UpdatePatientTwelveLeadReportNew]
    (
     @report_id UNIQUEIDENTIFIER,
     @interpretation NTEXT,
     @user_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_12lead_report_new]
    SET
        [interpretation_edits] = @interpretation,
        [user_id] = @user_id
    WHERE
        ([report_id] = @report_id);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'UpdatePatientTwelveLeadReportNew';

