CREATE TYPE [old].[utpTopicSession] AS TABLE (
    [TopicSessionID]   INT           NOT NULL,
    [TopicTypeID]      INT           NULL,
    [TopicInstanceID]  INT           NULL,
    [DeviceSessionID]  INT           NULL,
    [PatientSessionID] INT           NULL,
    [BeginDateTime]    DATETIME2 (7) NOT NULL,
    [EndDateTime]      DATETIME2 (7) NULL);

