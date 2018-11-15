CREATE TABLE [Intesys].[Environment] (
    [EnvironmentID]   INT            IDENTITY (1, 1) NOT NULL,
    [envwid]          INT            NOT NULL,
    [DisplayName]     NVARCHAR (50)  NOT NULL,
    [Url]             NVARCHAR (200) NULL,
    [SequenceNumber]  INT            NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_Environment_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Environment_EnvironmentID] PRIMARY KEY CLUSTERED ([EnvironmentID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Environment_envwid_SequenceNumber]
    ON [Intesys].[Environment]([envwid] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to store the "Environments" that a site has defined. Environments are shown on the CB homepage and allow a site to customize behaviour. Environments are a lot like products (e.x. L&D, NICU, ED, etc). Usually each environment has a patient list that is specific to the way that department works.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Environment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique identifier for each environment', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Environment', @level2type = N'COLUMN', @level2name = N'envwid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of environment', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Environment', @level2type = N'COLUMN', @level2name = N'DisplayName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequence to list environments in', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Environment', @level2type = N'COLUMN', @level2name = N'SequenceNumber';

