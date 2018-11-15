CREATE PROCEDURE [dbo].[usp_SaveStatusDataSet]
    (
     @statusData [dbo].NameValueDataSetType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[StatusDataSets]
            ([Id],
             [TopicSessionId],
             [FeedTypeId],
             [TimestampUTC]
            )
    SELECT DISTINCT
        [SetId] AS [Id],
        [TopicSessionId],
        [FeedTypeId],
        [TimestampUTC]
    FROM
        @statusData;

    INSERT  INTO [dbo].[StatusData]
            ([Id],
             [SetId],
             [Name],
             [Value]
            )
    SELECT
        [Id],
        [SetId],
        [Name],
        [Value]
    FROM
        @statusData;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveStatusDataSet';

