CREATE TABLE [dbo].[FileStats] (
    [DB]               NVARCHAR (128) NULL,
    [Drive]            NVARCHAR (2)   NULL,
    [type_desc]        NVARCHAR (60)  NULL,
    [Reads]            BIGINT         NULL,
    [Writes]           BIGINT         NULL,
    [ReadLatency(ms)]  BIGINT         NULL,
    [WriteLatency(ms)] BIGINT         NULL,
    [AvgBPerRead]      BIGINT         NULL,
    [AvgBPerWrite]     BIGINT         NULL,
    [physical_name]    NVARCHAR (260) NOT NULL,
    [CAPTURE_DATE]     DATETIME       NOT NULL
);

