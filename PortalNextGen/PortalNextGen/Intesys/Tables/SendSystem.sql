CREATE TABLE [Intesys].[SendSystem] (
    [SendSystemID]    INT            IDENTITY (1, 1) NOT NULL,
    [FlowsheetID]     INT            NOT NULL,
    [SystemID]        INT            NOT NULL,
    [OrganizationID]  INT            NOT NULL,
    [Code]            NVARCHAR (180) NOT NULL,
    [Description]     NVARCHAR (180) NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_SendSystem_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SendSystem_SendSystemID] PRIMARY KEY CLUSTERED ([SendSystemID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_SendSystem_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SendSystem_SystemID]
    ON [Intesys].[SendSystem]([SystemID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information for each system sending messages to be stored in the CIS database. Specifically, all system codes defined in the message header (MSH) Sending Application and Receiving Application fields must be loaded in this table. All system codes that are sent as application id''s for placer order numbers and filler order number (see HL7 segments ORC, OBR, and OBX) must be loaded into this table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SendSystem';

