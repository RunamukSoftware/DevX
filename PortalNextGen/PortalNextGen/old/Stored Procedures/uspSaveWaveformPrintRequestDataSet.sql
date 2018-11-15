CREATE PROCEDURE [old].[uspSaveWaveformPrintRequestDataSet]
    (
        @PrintRequestDataSetEntries [old].[utpPrintRequestEntry]  READONLY,
        @PrintRequestDataSet        [old].[utpPrintRequest]       READONLY,
        @ChannelInfoDataSet         [old].[utpChannelInformation] READONLY
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[PrintJob]
            (
                [PrintJobID],
                [TopicSessionID],
                [FeedTypeID]
            )
                    SELECT
                        [NewPrintJobs].[PrintJobID],
                        [NewPrintJobs].[TopicSessionID],
                        [NewPrintJobs].[FeedTypeID]
                    FROM
                        (
                            SELECT DISTINCT
                                [PrintJobID],
                                [TopicSessionID],
                                [FeedTypeID]
                            FROM
                                @PrintRequestDataSetEntries
                            WHERE
                                NOT EXISTS
                                (
                                    SELECT
                                        *
                                    FROM
                                        [old].[PrintJob]
                                    WHERE
                                        [PrintJob].[PrintJobID] = [PrintJobID]
                                )
                        ) AS [NewPrintJobs];

        INSERT INTO [old].[PrintRequest]
            (
                [PrintRequestID],
                [PrintJobID],
                [RequestTypeEnumValue],
                [RequestTypeEnumID],
                [Timestamp]
            )
                    SELECT
                        [PrintRequestID],
                        [PrintJobID],
                        [RequestTypeEnumValue],
                        [RequestTypeEnumID],
                        [Timestamp]
                    FROM
                        @PrintRequestDataSetEntries;

        INSERT INTO [old].[PrintRequestData]
            (
                [PrintRequestID],
                [Name],
                [Value]
            )
                    SELECT
                        [PrintRequestID],
                        [Name],
                        [Value]
                    FROM
                        @PrintRequestDataSet;

        INSERT INTO [old].[ChannelInformation]
            (
                [PrintRequestID],
                [ChannelIndex],
                [IsPrimaryECG],
                [IsSecondaryECG],
                [IsNonWaveformType],
                [SampleRate],
                [Scale],
                [ScaleValue],
                [ScaleMin],
                [ScaleMax],
                [ScaleTypeEnumValue],
                [Baseline],
                [YPointsPerUnit],
                [ChannelTypeID]
            )
                    SELECT
                        [PrintRequestID],
                        [ChannelIndex],
                        [IsPrimaryECG],
                        [IsSecondaryECG],
                        [IsNonWaveformType],
                        [SampleRate],
                        [Scale],
                        [ScaleValue],
                        [ScaleMin],
                        [ScaleMax],
                        [ScaleTypeEnumValue],
                        [Baseline],
                        [YPointsPerUnit],
                        [ChannelType]
                    FROM
                        @ChannelInfoDataSet;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveWaveformPrintRequestDataSet';

