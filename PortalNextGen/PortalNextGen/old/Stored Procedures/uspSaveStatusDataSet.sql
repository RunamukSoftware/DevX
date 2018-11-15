CREATE PROCEDURE [old].[uspSaveStatusDataSet] (@StatusData [old].[utpNameValue] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[StatusSet]
            (
                [StatusSetID],
                [TopicSessionID],
                [FeedTypeID],
                [Timestamp]
            )
                    SELECT DISTINCT
                        [SetID],
                        [TopicSessionID],
                        [FeedTypeID],
                        [Timestamp]
                    FROM
                        @StatusData;

        INSERT INTO [old].[Status]
            (
                [StatusID],
                [SetID],
                [Name],
                [Value]
            )
                    SELECT
                        [LiveDataID],
                        [SetID],
                        [Name],
                        [Value]
                    FROM
                        @StatusData;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveStatusDataSet';

