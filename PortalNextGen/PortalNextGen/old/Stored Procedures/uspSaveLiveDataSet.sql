CREATE PROCEDURE [old].[uspSaveLiveDataSet] (@LiveData [old].[utpNameValue] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[LiveData]
            (
                [LiveDataID],
                [TopicInstanceID],
                [FeedTypeID],
                [Name],
                [Value],
                [Timestamp]
            )
                    SELECT
                        [ld].[LiveDataID],
                        [ts].[TopicInstanceID],
                        [ld].[FeedTypeID],
                        [ld].[Name],
                        [ld].[Value],
                        [ld].[Timestamp]
                    FROM
                        @LiveData                AS [ld]
                        INNER JOIN
                            [old].[TopicSession] AS [ts]
                                ON [ts].[TopicSessionID] = [ld].[TopicSessionID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save the patient topic session live data from the caller via a table variable.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveLiveDataSet';

