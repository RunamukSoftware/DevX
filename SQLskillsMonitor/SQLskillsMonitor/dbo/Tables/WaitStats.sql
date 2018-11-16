CREATE TABLE [dbo].[WaitStats] (
    [WaitType]     NVARCHAR (60)   NOT NULL,
    [Wait_S]       DECIMAL (16, 2) NULL,
    [Resource_S]   DECIMAL (16, 2) NULL,
    [Signal_S]     DECIMAL (16, 2) NULL,
    [WaitCount]    BIGINT          NULL,
    [Percentage]   DECIMAL (5, 2)  NULL,
    [AvgWait_S]    DECIMAL (16, 4) NULL,
    [AvgRes_S]     DECIMAL (16, 4) NULL,
    [AvgSig_S]     DECIMAL (16, 4) NULL,
    [CAPTURE_DATE] DATETIME        NOT NULL
);

