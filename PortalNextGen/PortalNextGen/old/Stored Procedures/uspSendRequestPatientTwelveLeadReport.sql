CREATE PROCEDURE [old].[uspSendRequestPatientTwelveLeadReport]
    (
        @ReportID     INT,
        @send_request SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[TwelveLeadReportNew]
        SET
            [SendRequest] = @send_request
        WHERE
            [ReportID] = @ReportID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSendRequestPatientTwelveLeadReport';

