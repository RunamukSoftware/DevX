CREATE PROCEDURE [old].[uspSaveVitalsDataSet] (@vitalsData [old].[utpNameValue] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[Vital]
            (
                [SetID],
                [Name],
                [Value],
                [TopicSessionID],
                [FeedTypeID],
                [Timestamp]
            )
                    SELECT
                        [SetID],
                        [Name],
                        [Value],
                        [TopicSessionID],
                        [FeedTypeID],
                        [Timestamp]
                    FROM
                        @vitalsData;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveVitalsDataSet';

