CREATE PROCEDURE [old].[uspDeleteEventData]
    (
        @UserID    INT,
        @PatientID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [ae]
        FROM
            [old].[AnalysisEvent] AS [ae]
        WHERE
            [ae].[UserID] = @UserID
            AND [ae].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteEventData';

