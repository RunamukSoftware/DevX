CREATE PROCEDURE [dbo].[usp_SaveLimitChangeDataSet]
    (
     @limitChangeData [dbo].[LimitChangeDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[LimitChangeData]
    SELECT
        [Id],
        [High],
        [Low],
        [ExtremeHigh],
        [ExtremeLow],
        [Desat],
        [AcquiredDateTimeUTC],
        [TopicSessionId],
        [FeedTypeId],
        [EnumGroupId],
        [IDEnumValue]
    FROM
        @limitChangeData;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveLimitChangeDataSet';

