CREATE PROCEDURE [dbo].[usp_SaveEventsDataSet]
    (
     @eventsData [dbo].EventDataType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[EventsData]
            ([CategoryValue],
             [Type],
             [Subtype],
             [Value1],
             [Value2],
             [Status],
             [Valid_Leads],
             [TopicSessionId],
             [FeedTypeId],
             [TimestampUTC]
            )
    SELECT
        [CategoryValue],
        [Type],
        [Subtype],
        [Value1],
        [Value2],
        [Status],
        [Valid_Leads],
        [TopicSessionId],
        [FeedTypeId],
        [TimestampUTC]
    FROM
        @eventsData;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveEventsDataSet';

