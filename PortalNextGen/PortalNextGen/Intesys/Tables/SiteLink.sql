CREATE TABLE [Intesys].[SiteLink] (
    [SiteLinkID]      INT            IDENTITY (1, 1) NOT NULL,
    [LinkID]          INT            NOT NULL,
    [GroupName]       NVARCHAR (100) NOT NULL,
    [GroupRank]       INT            NOT NULL,
    [display_name]    NVARCHAR (100) NOT NULL,
    [DisplayRank]     INT            NOT NULL,
    [Url]             NVARCHAR (100) NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_SiteLink_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SiteLink_SiteLinkID] PRIMARY KEY CLUSTERED ([SiteLinkID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SiteLink_LinkID_GroupRank_DisplayRank]
    ON [Intesys].[SiteLink]([LinkID] ASC, [GroupRank] ASC, [DisplayRank] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the links (URL''s) that appear on the left-hand side of the Clinical Browser homepage. A site can customize the homepage by adding links and groupings of links. The system administration module has screens to allow a site to maintain this table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SiteLink';

