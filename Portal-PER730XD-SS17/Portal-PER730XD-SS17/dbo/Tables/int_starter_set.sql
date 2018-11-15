CREATE TABLE [dbo].[int_starter_set] (
    [set_type_cd] NVARCHAR (255) NULL,
    [guid]        NVARCHAR (255) NULL,
    [int_id1]     FLOAT (53)     NULL,
    [int_id2]     FLOAT (53)     NULL,
    [int_id3]     FLOAT (53)     NULL,
    [enu]         NVARCHAR (255) NULL,
    [fra]         NVARCHAR (255) NULL,
    [deu]         NVARCHAR (255) NULL,
    [esp]         NVARCHAR (255) NULL,
    [ita]         NVARCHAR (255) NULL,
    [nld]         NVARCHAR (255) NULL,
    [chs]         NVARCHAR (255) NULL,
    [cze]         NVARCHAR (255) NULL,
    [pol]         NVARCHAR (255) NULL,
    [ptb]         NVARCHAR (255) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used strictly for internationalizing the CB. It contains words within the starter data set that must be translated. This is done as part of configuring the site. Whenever the language of a site is changed, this table will drive the translation process. This is generally a one-time thing for each site. This is slightly different than the int_translate table which is being used 100% of the time to translate tags on web pages. This table is only referenced when the language of a site is changed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_starter_set';

