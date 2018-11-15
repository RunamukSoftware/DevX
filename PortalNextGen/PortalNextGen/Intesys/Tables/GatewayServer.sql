CREATE TABLE [Intesys].[GatewayServer] (
    [GatewayServerID] INT           IDENTITY (1, 1) NOT NULL,
    [GatewayID]       INT           NOT NULL,
    [ServerName]      NVARCHAR (50) NOT NULL,
    [Port]            INT           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_GatewayServer_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_GatewayServer_GatewayServerID] PRIMARY KEY CLUSTERED ([GatewayServerID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_GatewayServer_Gateway_GatewayID] FOREIGN KEY ([GatewayID]) REFERENCES [Intesys].[Gateway] ([GatewayID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_GatewayServer_GatewayID_ServerName]
    ON [Intesys].[GatewayServer]([GatewayID] ASC, [ServerName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data about the S5 central workstations.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'GatewayServer';

