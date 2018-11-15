CREATE TABLE [old].[MonitorX] (
    [Name]            VARCHAR (20)  NOT NULL,
    [DataLoader]      VARCHAR (10)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_MonitorX_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MonitorX_Name] PRIMARY KEY CLUSTERED ([Name] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_MonitorX_DataLoader]
    ON [old].[MonitorX]([DataLoader] ASC) WITH (FILLFACTOR = 100);

