CREATE TYPE [old].[utpOruMessage] AS TABLE (
    [MessageStatus]   CHAR (1)       NOT NULL,
    [MessageNumber]   CHAR (20)      NOT NULL,
    [LongText]        NVARCHAR (MAX) NULL,
    [ShortText]       NVARCHAR (255) NULL,
    [PatientID]       INT            NULL,
    [MshSystem]       NVARCHAR (50)  NOT NULL,
    [MshOrganization] NVARCHAR (50)  NOT NULL,
    [MshEventCode]    NVARCHAR (10)  NOT NULL,
    [MshMessageType]  NVARCHAR (10)  NOT NULL,
    [SentDateTime]    DATETIME2 (7)  NULL,
    [QueuedDateTime]  DATETIME2 (7)  NOT NULL);

