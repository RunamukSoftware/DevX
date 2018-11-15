CREATE PROCEDURE [old].[uspUpdateAnalysisInsertDateTime]
    (
        @UserID         INT,
        @PatientID      INT,
        @InsertDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [at]
        SET
            [at].[InsertDateTime] = @InsertDateTime
        FROM
            [old].[AnalysisTime] AS [at]
        WHERE
            [at].[PatientID] = @PatientID
            AND [at].[UserID] = @UserID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update analysis insert date.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateAnalysisInsertDateTime';

