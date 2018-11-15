CREATE PROCEDURE [old].[uspSaveLimitChangeDataSet] (@LimitChangeData [old].[utpLimitChange] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[LimitChange]
            (
                [High],
                [Low],
                [ExtremeHigh],
                [ExtremeLow],
                [Desat],
                [AcquiredDateTime],
                [TopicSessionID],
                [FeedTypeID],
                [EnumGroupID],
                [IDEnumValue]
            )
                    SELECT
                        [High],
                        [Low],
                        [ExtremeHigh],
                        [ExtremeLow],
                        [Desat],
                        [AcquiredDateTime],
                        [TopicSessionID],
                        [FeedTypeID],
                        [EnumGroupID],
                        [IDEnumValue]
                    FROM
                        @LimitChangeData;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveLimitChangeDataSet';

