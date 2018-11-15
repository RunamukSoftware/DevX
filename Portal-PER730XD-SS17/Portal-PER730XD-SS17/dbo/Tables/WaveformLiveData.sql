CREATE TABLE [dbo].[WaveformLiveData] (
    [Sequence]        BIGINT           IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [SampleCount]     INT              NOT NULL,
    [TypeName]        VARCHAR (50)     NOT NULL,
    [TypeId]          UNIQUEIDENTIFIER NOT NULL,
    [Samples]         VARBINARY (MAX)  NOT NULL,
    [TopicInstanceId] UNIQUEIDENTIFIER NOT NULL,
    [StartTimeUTC]    DATETIME         NOT NULL,
    [EndTimeUTC]      DATETIME         NOT NULL,
    [CreatedUTC]      DATETIME2 (7)    CONSTRAINT [DF_WaveformLiveData_CreatedUTC] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WaveformLiveData_TopicInstanceId_TypeId_EndTimeUTC_Sequence] PRIMARY KEY NONCLUSTERED ([TopicInstanceId] ASC, [TypeId] ASC, [EndTimeUTC] ASC, [Sequence] ASC)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);
GO
--ALTER TABLE [dbo].[WaveformLiveData]
--ADD CONSTRAINT [IX_WaveformLiveData_TopicInstanceId_TypeId_EndTimeUTC_StartTimeUTC_Id]
--    UNIQUE NONCLUSTERED
--    (
--    [TopicInstanceId] ASC,
--    [TypeId] ASC,
--    [EndTimeUTC] ASC,
--    [Sequence] ASC,
--    [StartTimeUTC] ASC,
--    [Id] ASC);
--GO
--EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the waveform live feed data for a patient topic session.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WaveformLiveData';
