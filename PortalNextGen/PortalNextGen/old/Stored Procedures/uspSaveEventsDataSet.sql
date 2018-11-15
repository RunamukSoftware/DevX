CREATE PROCEDURE [old].[uspSaveEventsDataSet] (@Events [old].[utpEvent] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[Event]
            (
                [CategoryValue],
                [Type],
                [Subtype],
                [Value1],
                [Value2],
                [Status],
                [ValidLeads],
                [TopicSessionID],
                [FeedTypeID],
                [Timestamp]
            )
                    SELECT
                        [CategoryValue],
                        [Type],
                        [Subtype],
                        [Value1],
                        [Value2],
                        [Status],
                        [Valid_Leads],
                        [TopicSessionID],
                        [FeedTypeID],
                        [Timestamp]
                    FROM
                        @Events;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventsDataSet';

