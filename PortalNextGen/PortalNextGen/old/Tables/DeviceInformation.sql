CREATE TABLE [old].[DeviceInformation] (
    [DeviceInformationID] INT            IDENTITY (1, 1) NOT NULL,
    [DeviceSessionID]     INT            NOT NULL,
    [Name]                NVARCHAR (25)  NOT NULL,
    [Value]               NVARCHAR (100) NOT NULL,
    [DateTimeStamp]       DATETIME2 (7)  NOT NULL,
    [CreatedDateTime]     DATETIME2 (7)  CONSTRAINT [DF_DeviceInformation_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DeviceInformation_DeviceInformationID] PRIMARY KEY CLUSTERED ([DeviceInformationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_DeviceInformation_DeviceSession__DeviceSessionID] FOREIGN KEY ([DeviceSessionID]) REFERENCES [old].[DeviceSession] ([DeviceSessionID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DeviceInformation_DeviceSessionID_Name_TimestampUTC_DeviceInformationID_Value]
    ON [old].[DeviceInformation]([DeviceSessionID] ASC, [Name] ASC, [DateTimeStamp] DESC, [DeviceInformationID] ASC)
    INCLUDE([Value]) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DeviceInformation_DeviceSessionID_Name_DateTimeStamp]
    ON [old].[DeviceInformation]([DeviceSessionID] ASC, [Name] ASC, [DateTimeStamp] DESC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_DeviceInformation_Name_DeviceSessionId_Value_DateTimeStamp]
    ON [old].[DeviceInformation]([Name] ASC)
    INCLUDE([DeviceSessionID], [Value], [DateTimeStamp]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'DeviceInformation';

