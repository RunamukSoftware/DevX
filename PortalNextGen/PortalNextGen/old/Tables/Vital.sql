CREATE TABLE [old].[Vital] (
    [VitalID]         INT           IDENTITY (1, 1) NOT NULL,
    [SetID]           INT           NOT NULL,
    [Name]            VARCHAR (25)  NOT NULL,
    [Value]           VARCHAR (25)  NULL,
    [TopicSessionID]  INT           NOT NULL,
    [FeedTypeID]      INT           NOT NULL,
    [Timestamp]       DATETIME2 (7) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Vital_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Vital_VitalID] PRIMARY KEY CLUSTERED ([VitalID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Vital_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID]),
    CONSTRAINT [FK_Vital_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_VitalsData_Timestamp]
    ON [old].[Vital]([Timestamp] ASC, [VitalID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Vital_TopicSessionID_TimestampUTC_Name_FeedTypeID_VitalID_Value]
    ON [old].[Vital]([TopicSessionID] ASC, [Timestamp] ASC, [Name] ASC, [FeedTypeID] ASC)
    INCLUDE([VitalID], [Value]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Vital_Name_FeedTypeID_Value_TopicSessionID_Timestamp]
    ON [old].[Vital]([Name] ASC, [FeedTypeID] ASC)
    INCLUDE([Value], [TopicSessionID], [Timestamp]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient vital sign data', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Vital';

