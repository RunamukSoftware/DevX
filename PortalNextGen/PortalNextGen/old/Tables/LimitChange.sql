CREATE TABLE [old].[LimitChange] (
    [LimitChangeID]    INT           IDENTITY (1, 1) NOT NULL,
    [High]             VARCHAR (25)  NULL,
    [Low]              VARCHAR (25)  NULL,
    [ExtremeHigh]      VARCHAR (25)  NULL,
    [ExtremeLow]       VARCHAR (25)  NULL,
    [Desat]            VARCHAR (25)  NULL,
    [AcquiredDateTime] DATETIME2 (7) NOT NULL,
    [TopicSessionID]   INT           NOT NULL,
    [FeedTypeID]       INT           NOT NULL,
    [EnumGroupID]      INT           NOT NULL,
    [IDEnumValue]      INT           NOT NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_LimitChange_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_LimitChange_LimitChangeID] PRIMARY KEY CLUSTERED ([LimitChangeID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_LimitChange_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Records changes to limit values.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'LimitChange';

