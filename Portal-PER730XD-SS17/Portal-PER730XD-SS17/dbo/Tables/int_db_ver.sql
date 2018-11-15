CREATE TABLE [dbo].[int_db_ver] (
    [ver_code]               VARCHAR (30)  NOT NULL,
    [install_dt]             DATETIME      CONSTRAINT [DF_int_db_ver_install_dt] DEFAULT (sysutcdatetime()) NOT NULL,
    [status_cd]              VARCHAR (30)  NULL,
    [pre_install_pgm]        VARCHAR (255) NULL,
    [pre_install_pgm_flags]  VARCHAR (30)  NULL,
    [install_pgm]            VARCHAR (255) NULL,
    [install_pgm_flags]      VARCHAR (30)  NULL,
    [post_install_pgm]       VARCHAR (255) NULL,
    [post_install_pgm_flags] VARCHAR (30)  NULL,
    CONSTRAINT [PK_int_db_ver_ver_code] PRIMARY KEY CLUSTERED ([ver_code] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the current version of the database as well as the history of prior versions. As the Clinical Browser is installed/upgraded over time, new records will be inserted into this table. The current version of the database schema is the record with the latest install_dt with a status of "Complete".', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code of the version. Ex: 1.01.03. This should match the version of code running on the servers (one with most recent install_dt)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'ver_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date (in UTC) that this version was installed and became active.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'install_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The status of the release. Currently only "Complete" is used. There can be multiple records with "Complete", so the one with the most recent install_dt is the currently active release.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'status_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'pre_install_pgm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'pre_install_pgm_flags';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'install_pgm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'install_pgm_flags';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'post_install_pgm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to help auto-update workstations. Not used in the web-based solution.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_db_ver', @level2type = N'COLUMN', @level2name = N'post_install_pgm_flags';

