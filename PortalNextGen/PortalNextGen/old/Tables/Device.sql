CREATE TABLE [old].[Device] (
    [DeviceID]        INT           NOT NULL,
    [Name]            VARCHAR (50)  NOT NULL,
    [Description]     VARCHAR (50)  NOT NULL,
    [Room]            VARCHAR (12)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Device_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Device_DeviceID] PRIMARY KEY CLUSTERED ([DeviceID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_Device_DeviceID_Name_Room]
    ON [old].[Device]([DeviceID] ASC)
    INCLUDE([Name], [Room]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Device';

