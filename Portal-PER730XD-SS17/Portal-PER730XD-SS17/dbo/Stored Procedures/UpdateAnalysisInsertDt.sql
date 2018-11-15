CREATE PROCEDURE [dbo].[UpdateAnalysisInsertDt]
    (
     @patient_id UNIQUEIDENTIFIER,
     @user_id UNIQUEIDENTIFIER,
     @insert_dt DATETIME
    )
AS
BEGIN
    UPDATE
        [at]
    SET
        [at].[insert_dt] = @insert_dt
    FROM
        [dbo].[AnalysisTime] AS [at]
    WHERE
        [at].[patient_id] = @patient_id
        AND [at].[user_id] = @user_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update analysis insert date.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'UpdateAnalysisInsertDt';

