CREATE TABLE [Intesys].[Monitor] (
    [MonitorID]          INT           IDENTITY (1, 1) NOT NULL,
    [UnitOrganizationID] INT           NULL,
    [NetworkID]          NVARCHAR (15) NOT NULL,
    [NodeID]             NVARCHAR (15) NOT NULL,
    [BedID]              NVARCHAR (3)  NOT NULL,
    [BedCode]            NVARCHAR (20) NULL,
    [Room]               NVARCHAR (12) NULL,
    [MonitorDescription] NVARCHAR (50) NULL,
    [MonitorName]        NVARCHAR (30) NOT NULL,
    [MonitorTypeCode]    VARCHAR (5)   NULL,
    [Subnet]             NVARCHAR (50) NULL,
    [Standby]            TINYINT       NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_Monitor_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Monitor_MonitorID] PRIMARY KEY CLUSTERED ([MonitorID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_Monitor_UnitOrganizationID_NetworkID_NodeID_BedID]
    ON [Intesys].[Monitor]([UnitOrganizationID] ASC, [NetworkID] ASC, [NodeID] ASC, [BedID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all monitors known by all gateways. Records are dynamically added/updated in this table as the monitor Loader service(s) run. Monitor records are NOT dynamically removed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Monitor';

