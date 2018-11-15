CREATE PROCEDURE [old].[uspUpdatePatientTwelveLeadReport]
    (
        @ReportID       INT,
        @Interpretation VARCHAR(256)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[TwelveLeadReportNew]
        SET
            [Interpretation] = @Interpretation
        WHERE
            [ReportID] = @ReportID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientTwelveLeadReport';

