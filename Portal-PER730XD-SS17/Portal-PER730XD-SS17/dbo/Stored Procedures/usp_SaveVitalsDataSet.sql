CREATE PROCEDURE [dbo].[usp_SaveVitalsDataSet]
    (
     @vitalsData [dbo].NameValueDataSetType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[VitalsData]
            ([SetId],
             [Name],
             [Value],
             [TopicSessionId],
             [FeedTypeId],
             [TimestampUTC]
            )
    SELECT
        [SetId],
        [Name],
        [Value],
        [TopicSessionId],
        [FeedTypeId],
        [TimestampUTC]
    FROM
        @vitalsData;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveVitalsDataSet';

