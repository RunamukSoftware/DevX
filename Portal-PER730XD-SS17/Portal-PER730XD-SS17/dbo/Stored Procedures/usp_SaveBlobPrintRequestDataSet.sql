CREATE PROCEDURE [dbo].[usp_SaveBlobPrintRequestDataSet]
    (
     @PrintRequestDataSetEntries [dbo].[PrintRequestDataSetEntriesType] READONLY,
     @PrintRequestDataSet [dbo].[PrintRequestDataType] READONLY,
     @BlobDataSet [dbo].[BlobDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[PrintJobs]
            ([Id],
             [TopicSessionId],
             [FeedTypeId]
            )
    SELECT
        [PrintJobId] AS [Id],
        [TopicSessionId],
        [FeedTypeId]
    FROM
        (SELECT DISTINCT
            [PrintJobId],
            [TopicSessionId],
            [FeedTypeId]
         FROM
            @PrintRequestDataSetEntries
         WHERE
            NOT EXISTS ( SELECT
                            *
                         FROM
                            [dbo].[PrintJobs]
                         WHERE
                            [PrintJobs].[Id] = [PrintJobId] )
        ) [NewPrintJobs];

    INSERT  INTO [dbo].[PrintRequests]
            ([Id],
             [PrintJobId],
             [RequestTypeEnumValue],
             [RequestTypeEnumId],
             [TimestampUTC]
            )
    SELECT
        [PrintRequestId] AS [Id],
        [PrintJobId],
        [RequestTypeEnumValue],
        [RequestTypeEnumId],
        [TimestampUTC]
    FROM
        @PrintRequestDataSetEntries;

    INSERT  INTO [dbo].[PrintRequestData]
    SELECT
        [Id],
        [PrintRequestId],
        [Name],
        [Value]
    FROM
        @PrintRequestDataSet;

    INSERT  INTO [dbo].[PrintBlobData]
    SELECT
        [Id],
        [PrintRequestId],
        [NumBytes],
        [Value]
    FROM
        @BlobDataSet;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveBlobPrintRequestDataSet';

