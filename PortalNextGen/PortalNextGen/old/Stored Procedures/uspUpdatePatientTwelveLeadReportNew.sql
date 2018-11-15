CREATE PROCEDURE [old].[uspUpdatePatientTwelveLeadReportNew]
    (
        @UserID         INT,
        @ReportID       INT,
        @interpretation NVARCHAR(MAX)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[TwelveLeadReportNew]
        SET
            [InterpretationEdits] = @interpretation,
            [UserID] = @UserID
        WHERE
            [ReportID] = @ReportID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientTwelveLeadReportNew';

