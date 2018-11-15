CREATE TABLE [Intesys].[StarterSet] (
    [StarterSetID]    INT            IDENTITY (1, 1) NOT NULL,
    [SetTypeCode]     NVARCHAR (255) NULL,
    [Guid]            NVARCHAR (255) NULL,
    [ID1]             FLOAT (53)     NULL,
    [ID2]             FLOAT (53)     NULL,
    [ID3]             FLOAT (53)     NULL,
    [Enu]             NVARCHAR (255) NULL,
    [Fra]             NVARCHAR (255) NULL,
    [Deu]             NVARCHAR (255) NULL,
    [Esp]             NVARCHAR (255) NULL,
    [Ita]             NVARCHAR (255) NULL,
    [Nld]             NVARCHAR (255) NULL,
    [Chs]             NVARCHAR (255) NULL,
    [Cze]             NVARCHAR (255) NULL,
    [Pol]             NVARCHAR (255) NULL,
    [Ptb]             NVARCHAR (255) NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_StarterSet_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_StarterSet_StarterSetID] PRIMARY KEY CLUSTERED ([StarterSetID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used strictly for internationalizing the CB. It contains words within the starter data set that must be translated. This is done as part of configuring the site. Whenever the language of a site is changed, this table will drive the translation process. This is generally a one-time thing for each site. This is slightly different than the int_translate table which is being used 100% of the time to translate tags on web pages. This table is only referenced when the language of a site is changed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'StarterSet';

