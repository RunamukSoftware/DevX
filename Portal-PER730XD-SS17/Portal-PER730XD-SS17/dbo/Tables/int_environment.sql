CREATE TABLE [dbo].[int_environment] (
    [env_id]       UNIQUEIDENTIFIER NOT NULL,
    [display_name] NVARCHAR (50)    NOT NULL,
    [url]          NVARCHAR (200)   NULL,
    [seq]          INT              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_environment_env_id_seq]
    ON [dbo].[int_environment]([env_id] ASC, [seq] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to store the "Environments" that a site has defined. Environments are shown on the CB homepage and allow a site to customize behaviour. Environments are a lot like products (e.x. L&D, NICU, ED, etc). Usually each environment has a patient list that is specific to the way that department works.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_environment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique identifier for each environment', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_environment', @level2type = N'COLUMN', @level2name = N'env_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of environment', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_environment', @level2type = N'COLUMN', @level2name = N'display_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequence to list environments in', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_environment', @level2type = N'COLUMN', @level2name = N'seq';

