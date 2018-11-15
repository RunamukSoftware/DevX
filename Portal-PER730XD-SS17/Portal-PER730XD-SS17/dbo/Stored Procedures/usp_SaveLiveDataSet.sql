CREATE PROCEDURE [dbo].[usp_SaveLiveDataSet]
    (
     @LiveData [dbo].[NameValueDataSetType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[LiveData]
            ([Id],
             [TopicInstanceId],
             [FeedTypeId],
             [Name],
             [Value],
             [TimestampUTC])
    SELECT
        [ld].[Id],
        [ts].[TopicInstanceId],
        [ld].[FeedTypeId],
        [ld].[Name],
        [ld].[Value],
        [ld].[TimestampUTC]
    FROM
        @LiveData AS [ld]
        INNER JOIN [dbo].[TopicSessions] AS [ts]
            ON [ts].[Id] = [ld].[TopicSessionId];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save the patient topic session live data from the caller via a table variable.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveLiveDataSet';

