CREATE TABLE [dbo].[int_site_link] (
    [link_id]      UNIQUEIDENTIFIER NOT NULL,
    [group_name]   NVARCHAR (100)   NOT NULL,
    [group_rank]   INT              NOT NULL,
    [display_name] NVARCHAR (100)   NOT NULL,
    [display_rank] INT              NOT NULL,
    [url]          NVARCHAR (100)   NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_site_link_link_id_group_rank_display_rank]
    ON [dbo].[int_site_link]([link_id] ASC, [group_rank] ASC, [display_rank] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the links (URL''s) that appear on the left-hand side of the Clinical Browser homepage. A site can customize the homepage by adding links and groupings of links. The system administration module has screens to allow a site to maintain this table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_site_link';

