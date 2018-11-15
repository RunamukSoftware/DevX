CREATE TABLE [old].[Log] (
    [LogID]            BIGINT         IDENTITY (-9223372036854775808, 1) NOT NULL,
    [DateTime]         DATETIME2 (7)  NOT NULL,
    [PatientID]        INT            NOT NULL,
    [Application]      NVARCHAR (256) NOT NULL,
    [DeviceName]       NVARCHAR (256) NOT NULL,
    [Message]          NVARCHAR (MAX) NOT NULL,
    [LocalizedMessage] NVARCHAR (MAX) NOT NULL,
    [MessageID]        INT            NOT NULL,
    [LogType]          NVARCHAR (64)  NOT NULL,
    [CreatedDateTime]  DATETIME2 (7)  CONSTRAINT [DF_Log_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Log_LogID] PRIMARY KEY CLUSTERED ([LogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Log_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains error log information', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Log';

