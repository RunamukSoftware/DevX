CREATE TABLE [dbo].[LimitChangeData] (
    [Id]                  UNIQUEIDENTIFIER NOT NULL,
    [High]                VARCHAR (25)     NULL,
    [Low]                 VARCHAR (25)     NULL,
    [ExtremeHigh]         VARCHAR (25)     NULL,
    [ExtremeLow]          VARCHAR (25)     NULL,
    [Desat]               VARCHAR (25)     NULL,
    [AcquiredDateTimeUTC] DATETIME         NOT NULL,
    [TopicSessionId]      UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]          UNIQUEIDENTIFIER NOT NULL,
    [EnumGroupId]         UNIQUEIDENTIFIER NOT NULL,
    [IDEnumValue]         INT              NOT NULL,
    [Sequence]            BIGINT           IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [PK_LimitChangeData_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Records changes to limit values.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'LimitChangeData';

