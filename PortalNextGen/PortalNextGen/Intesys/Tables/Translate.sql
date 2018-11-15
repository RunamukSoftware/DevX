CREATE TABLE [Intesys].[Translate] (
    [TranslateID]     INT            IDENTITY (1, 1) NOT NULL,
    [TranslateCode]   VARCHAR (70)   NOT NULL,
    [FormID]          VARCHAR (30)   NULL,
    [enu]             NVARCHAR (255) NULL,
    [fra]             NVARCHAR (255) NULL,
    [deu]             NVARCHAR (255) NULL,
    [esp]             NVARCHAR (255) NULL,
    [ita]             NVARCHAR (255) NULL,
    [nld]             NVARCHAR (255) NULL,
    [chs]             NVARCHAR (255) NULL,
    [InsertDateTime]  DATETIME2 (7)  NOT NULL,
    [Pol]             NVARCHAR (255) NULL,
    [ptb]             NVARCHAR (255) NULL,
    [cze]             NVARCHAR (255) NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_Translate_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Translate_TranslateID] PRIMARY KEY CLUSTERED ([TranslateID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Translate_TranslateCode]
    ON [Intesys].[Translate]([TranslateCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to support internationalization of the Clinical Browser. Every literal string in the entire system has an entry in this table. Each language that is supported by the Clinical Browser has a column in this table. At run-time, the web server translates the literals into the appropriate language based upon a registry entry on the server.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Translate';

