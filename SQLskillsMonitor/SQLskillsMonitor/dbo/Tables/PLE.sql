CREATE TABLE [dbo].[PLE] (
    [INSTANCE]     NVARCHAR (128) NULL,
    [CAPTURE_DATE] DATETIME       NOT NULL,
    [OBJECT_NAME]  NCHAR (128)    NOT NULL,
    [COUNTER_NAME] NCHAR (128)    NOT NULL,
    [UPTIME_MIN]   INT            NULL,
    [PLE_SECS]     BIGINT         NOT NULL,
    [PLE_MINS]     BIGINT         NULL,
    [PLE_HOURS]    BIGINT         NULL,
    [PLE_DAYS]     BIGINT         NULL
);

