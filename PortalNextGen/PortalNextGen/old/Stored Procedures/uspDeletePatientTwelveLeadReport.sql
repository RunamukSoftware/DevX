CREATE PROCEDURE [old].[uspDeletePatientTwelveLeadReport] (@ReportID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [Intesys].[TwelveLeadReport]
        WHERE
            ([ReportID] = @ReportID);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeletePatientTwelveLeadReport';

