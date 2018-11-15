CREATE TABLE [old].[AuditLog] (
    [AuditLogID]      INT            IDENTITY (1, 1) NOT NULL,
    [AuditID]         INT            NOT NULL,
    [AuditDateTime]   DATETIME2 (7)  NOT NULL,
    [PatientID]       INT            NOT NULL,
    [Application]     NVARCHAR (256) NOT NULL,
    [DeviceName]      NVARCHAR (256) NOT NULL,
    [Message]         NVARCHAR (MAX) NOT NULL,
    [ItemName]        NVARCHAR (256) NOT NULL,
    [OriginalValue]   NVARCHAR (MAX) NOT NULL,
    [NewValue]        NVARCHAR (MAX) NOT NULL,
    [ChangedBy]       NVARCHAR (64)  NOT NULL,
    [HashedValue]     BINARY (20)    NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_AuditLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AuditLog_AuditLogID] PRIMARY KEY CLUSTERED ([AuditLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AuditLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains audit log information', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'AuditLog';

