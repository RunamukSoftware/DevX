CREATE PROCEDURE [old].[uspDeleteAnalysisTime]
    (
        @UserID    INT,
        @PatientID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [old].[AnalysisTime]
        WHERE
            [UserID] = @UserID
            AND [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteAnalysisTime';

