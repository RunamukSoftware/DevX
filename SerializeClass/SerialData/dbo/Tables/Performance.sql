CREATE TABLE [dbo].[Performance]
    (
        [PerformanceID]  INT         IDENTITY(1, 1) NOT NULL
            CONSTRAINT [PK_Performance_PerformanceID] PRIMARY KEY CLUSTERED,
        [DataType]       VARCHAR(50) NOT NULL,
        [RowsWritten]    INT         NOT NULL,
        [StartDateTime]  DATETIME2   NOT NULL,
        [EndDateTime]    DATETIME2   NOT NULL,
        [CreateDateTime] DATETIME2   NOT NULL
            CONSTRAINT [DF_Performance_CreateDateTime]
                DEFAULT (SYSUTCDATETIME())
    );
