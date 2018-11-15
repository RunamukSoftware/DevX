CREATE TABLE [Intesys].[UserSavedEvent] (
    [UserSavedEventID]      INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]             INT           NOT NULL,
    [EventID]               BIGINT        NOT NULL,
    [OriginalPatientID]     INT           NULL,
    [InsertDateTime]        DATETIME2 (7) NOT NULL,
    [UserID]                INT           NOT NULL,
    [OriginalEventCategory] INT           NOT NULL,
    [OriginalEventType]     INT           NOT NULL,
    [StartDateTime]         DATETIME2 (7) NOT NULL,
    [CenterDateTime]        DATETIME2 (7) NULL,
    [Duration]              INT           NOT NULL,
    [Value1]                INT           NOT NULL,
    [Divisor1]              INT           NOT NULL,
    [Value2]                INT           NULL,
    [Divisor2]              INT           NULL,
    [PrintFormat]           INT           NOT NULL,
    [Title]                 NVARCHAR (50) NULL,
    [Type]                  NVARCHAR (50) NULL,
    [RateCalipers]          TINYINT       NOT NULL,
    [MeasureCalipers]       TINYINT       NOT NULL,
    [CaliperStartDateTime]  INT           NULL,
    [CaliperEndDateTime]    INT           NULL,
    [CaliperTop]            INT           NULL,
    [CaliperBottom]         INT           NULL,
    [CaliperTopWaveType]    INT           NULL,
    [CaliperBottomWaveType] INT           NULL,
    [AnnotateData]          TINYINT       NOT NULL,
    [NumberOfWaveforms]     INT           NOT NULL,
    [CreatedDateTime]       DATETIME2 (7) CONSTRAINT [DF_UserSavedEvent_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_UserSavedEvent_UserSavedEventID] PRIMARY KEY CLUSTERED ([UserSavedEventID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_UserSavedEvent_Event_EventID] FOREIGN KEY ([EventID]) REFERENCES [old].[Event] ([EventID]),
    CONSTRAINT [FK_UserSavedEvent_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_UserSavedEvent_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserSavedEvent_PatientID_EventID_InsertDateTime_UserID]
    ON [Intesys].[UserSavedEvent]([PatientID] ASC, [EventID] ASC, [InsertDateTime] ASC, [UserID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores events manually saved by the user. Each record is uniquely identified by PatientID, EventID and InsertDateTime. The data in this table is populated by the Patsrvr process. New records are added and no records are deleted.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'UserSavedEvent';

