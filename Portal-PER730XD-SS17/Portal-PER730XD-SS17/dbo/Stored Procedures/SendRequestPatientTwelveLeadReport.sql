CREATE PROCEDURE [dbo].[SendRequestPatientTwelveLeadReport]
    (
     @report_id UNIQUEIDENTIFIER,
     @send_request SMALLINT
    )
AS
BEGIN
    UPDATE
        [dbo].[int_12lead_report_new]
    SET
        [send_request] = @send_request
    WHERE
        [report_id] = @report_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SendRequestPatientTwelveLeadReport';

