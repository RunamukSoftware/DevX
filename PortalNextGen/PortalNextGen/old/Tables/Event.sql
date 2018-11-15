CREATE TABLE [old].[Event] (
    [EventID]         BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [CategoryValue]   INT           NOT NULL,
    [Type]            INT           NOT NULL,
    [Subtype]         INT           NOT NULL,
    [Value1]          REAL          NOT NULL,
    [Value2]          REAL          NOT NULL,
    [Status]          INT           NOT NULL,
    [ValidLeads]      INT           NOT NULL,
    [TopicSessionID]  INT           NOT NULL,
    [FeedTypeID]      INT           NOT NULL,
    [Timestamp]       DATETIME2 (7) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Event_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Event_EventID] PRIMARY KEY CLUSTERED ([EventID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Event_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID]),
    CONSTRAINT [FK_Event_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Event_TimeStamp_EventID]
    ON [old].[Event]([Timestamp] ASC, [EventID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_EventsData_CategoryValue_Type_TopicSessionID_Subtype_Value1_Status_ValidLeads_TimeStamp]
    ON [old].[Event]([CategoryValue] ASC, [Type] ASC, [TopicSessionID] ASC)
    INCLUDE([Subtype], [Value1], [Status], [ValidLeads], [Timestamp]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_EventsData_CategoryValue_TopicSessionID_TimestampUTC_Type_Subtype_Value1_Value2_Status_Valid_Leads]
    ON [old].[Event]([CategoryValue] ASC, [TopicSessionID] ASC, [Timestamp] ASC)
    INCLUDE([Type], [Subtype], [Value1], [Value2], [Status], [ValidLeads]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data from the XTR/ETR receivers.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Event';

