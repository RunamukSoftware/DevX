CREATE TABLE [Intesys].[MonitorRequest] (
    [MonitorRequestID] INT            IDENTITY (1, 1) NOT NULL,
    [MonitorID]        INT            NOT NULL,
    [RequestType]      NVARCHAR (10)  NOT NULL,
    [RequestArguments] NVARCHAR (100) NULL,
    [Status]           NCHAR (2)      NULL,
    [ModifiedDateTime] DATETIME2 (7)  CONSTRAINT [DF_MonitorRequest_ModifiedDateTime] DEFAULT (getutcdate()) NOT NULL,
    [CreatedDateTime]  DATETIME2 (7)  CONSTRAINT [DF_MonitorRequest_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MonitorRequest_MonitorRequestID] PRIMARY KEY CLUSTERED ([MonitorRequestID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the request for monitors'' information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'MonitorRequest';

