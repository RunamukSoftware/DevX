CREATE TABLE [dbo].[WaveformData] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [SampleCount]     INT              NOT NULL,
    [TypeName]        VARCHAR (50)     NULL,
    [TypeId]          UNIQUEIDENTIFIER NULL,
    [Samples]         VARBINARY (MAX)  NOT NULL,
    [Compressed]      BIT              NOT NULL,
    [TopicSessionId]  UNIQUEIDENTIFIER NOT NULL,
    [StartTimeUTC]    DATETIME         NOT NULL,
    [EndTimeUTC]      DATETIME         NOT NULL,
    [Sequence]        BIGINT           IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    [CreatedDateTime] DATETIME2 (7)    CONSTRAINT [DF_WaveformData_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WaveformData_StartTimeUTC_Sequence] PRIMARY KEY CLUSTERED ([StartTimeUTC] ASC, [Sequence] ASC) WITH (FILLFACTOR = 100)
);


GO

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WaveformData';

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WaveformData_TopicSessionId_StartTimeUTC_EndTimeUTC_TypeId_Sequence]
    ON [dbo].[WaveformData]([TopicSessionId] ASC, [StartTimeUTC] ASC, [EndTimeUTC] ASC, [TypeId] ASC, [Sequence] ASC) WITH (FILLFACTOR = 100);

