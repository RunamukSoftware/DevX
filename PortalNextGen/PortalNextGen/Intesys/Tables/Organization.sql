CREATE TABLE [Intesys].[Organization] (
    [OrganizationID]       INT            IDENTITY (1, 1) NOT NULL,
    [CategoryCode]         CHAR (1)       NOT NULL,
    [ParentOrganizationID] INT            NULL,
    [OrganizationCode]     NVARCHAR (180) NOT NULL,
    [OrganizationName]     NVARCHAR (180) NOT NULL,
    [InDefaultSwitch]      BIT            NOT NULL,
    [MonitorDisableSwitch] BIT            NOT NULL,
    [AutoCollectInterval]  INT            NOT NULL,
    [OutboundInterval]     INT            NOT NULL,
    [PrinterName]          VARCHAR (255)  NOT NULL,
    [AlarmPrinterName]     VARCHAR (255)  NOT NULL,
    [CreatedDateTime]      DATETIME2 (7)  CONSTRAINT [DF_Organization_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Organization_OrganizationID] PRIMARY KEY CLUSTERED ([OrganizationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [CK_Organization_CategoryCode] CHECK ([CategoryCode]='D' OR [CategoryCode]='F' OR [CategoryCode]='O')
);


GO
CREATE NONCLUSTERED INDEX [IX_Organization_ParentOrganizationID_AutoCollectInterval_OrganizationCode_OrganizationName]
    ON [Intesys].[Organization]([ParentOrganizationID] ASC)
    INCLUDE([AutoCollectInterval], [OrganizationCode], [OrganizationName]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Organization_OrganizationID_ParentOrganizationID_CategoryCode_AutoCollectInterval_OrganizationCode_OrganizationName]
    ON [Intesys].[Organization]([OrganizationID] ASC, [ParentOrganizationID] ASC, [CategoryCode] ASC)
    INCLUDE([AutoCollectInterval], [OrganizationCode], [OrganizationName]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Organization_OrganizationID_ParentOrganizationID_CategoryCode_OrganizationCode_OrganizationName]
    ON [Intesys].[Organization]([OrganizationID] ASC, [ParentOrganizationID] ASC, [CategoryCode] ASC)
    INCLUDE([OrganizationCode], [OrganizationName]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Organization_OrganizationID_ParentOrganizationID_AutoCollectInterval_OrganizationCode_OrganizationName]
    ON [Intesys].[Organization]([OrganizationID] ASC, [ParentOrganizationID] ASC)
    INCLUDE([AutoCollectInterval], [OrganizationCode], [OrganizationName]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Organization_CategoryCode_AutoCollectInterval_OrganizationCode_OrganizationName_ParentOrganizationID]
    ON [Intesys].[Organization]([CategoryCode] ASC)
    INCLUDE([AutoCollectInterval], [OrganizationCode], [OrganizationName], [ParentOrganizationID]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the organizational structure of the enterprise. It describes a "tree structure" which includes the organization, facilities and units. This table must be defined before HL7 messages are played in since Feeder systems are defined as part of each Facility.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Organization';

