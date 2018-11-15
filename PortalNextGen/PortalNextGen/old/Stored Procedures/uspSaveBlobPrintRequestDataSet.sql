CREATE PROCEDURE [old].[uspSaveBlobPrintRequestDataSet]
    (
        @PrintRequestDataSetEntries [old].[utpPrintRequestEntry] READONLY,
        @PrintRequestDataSet        [old].[utpPrintRequest]      READONLY,
        @BlobDataSet                [old].[utpBlobData]          READONLY
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
                [PrintJobID],
                [RequestTypeEnumValue],
                [RequestTypeEnumID],
                [Timestamp]
            )
                    SELECT
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

        INSERT INTO [old].[PrintBlob]
            (
                [PrintRequestID],
                [NumberOfBytes],
                [Value]
            )
                    SELECT
                        [PrintRequestID],
                        [NumberOfBytes],
                        [Value]
                    FROM
                        @BlobDataSet;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveBlobPrintRequestDataSet';

