CREATE TABLE [Configuration].[DatabaseVersion] (
    [DatabaseVersionID]       INT           IDENTITY (1, 1) NOT NULL,
    [VersionCode]             VARCHAR (30)  NOT NULL,
    [InstallDateTime]         DATETIME2 (7) NOT NULL,
    [StatusCode]              VARCHAR (30)  NULL,
    [PreInstallProgram]       VARCHAR (255) NULL,
    [PreInstallProgramFlags]  VARCHAR (30)  NULL,
    [InstallProgram]          VARCHAR (255) NULL,
    [InstallProgramFlags]     VARCHAR (30)  NULL,
    [PostInstallProgram]      VARCHAR (255) NULL,
    [PostInstallProgramFlags] VARCHAR (30)  NULL,
    [CreatedDateTime]         DATETIME2 (7) CONSTRAINT [DF_DatabaseVersion_CreateDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DatabaseVersion_DatabaseVersionID] PRIMARY KEY CLUSTERED ([DatabaseVersionID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DatabaseVersion_VersionCode]
    ON [Configuration].[DatabaseVersion]([VersionCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the current version of the database as well as the history of prior versions. As the Clinical Browser is installed/upgraded over time, new records will be inserted into this table. The current version of the database schema is the record with the latest install date/time with a status of "Complete".', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code of the version. Ex: 1.01.03. This should match the version of code running on the servers (one with most recent install date/time)', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'VersionCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date this version was installed (and became active).', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'InstallDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The status of the release. Currently only "Complete" is used. There can be multiple records with "Complete", so the one with the most recent install date/time is the currently active release.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'StatusCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'PreInstallProgram';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'PreInstallProgramFlags';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'InstallProgram';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'InstallProgramFlags';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'PostInstallProgram';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'PostInstallProgramFlags';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time the row was inserted into the table. Also can be used to help select the latest version number inserted.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'DatabaseVersion', @level2type = N'COLUMN', @level2name = N'CreatedDateTime';

