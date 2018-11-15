CREATE TABLE [dbo].[int_translate] (
    [translate_cd] VARCHAR (70)   NOT NULL,
    [form_id]      VARCHAR (30)   NULL,
    [enu]          NVARCHAR (255) NULL,
    [fra]          NVARCHAR (255) NULL,
    [deu]          NVARCHAR (255) NULL,
    [esp]          NVARCHAR (255) NULL,
    [ita]          NVARCHAR (255) NULL,
    [nld]          NVARCHAR (255) NULL,
    [chs]          NVARCHAR (255) NULL,
    [insert_dt]    DATETIME       NOT NULL,
    [Pol]          NVARCHAR (255) NULL,
    [ptb]          NVARCHAR (255) NULL,
    [cze]          NVARCHAR (255) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_translate_translate_cd]
    ON [dbo].[int_translate]([translate_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to support internationalization of the Clinical Browser. Every literal string in the entire system has an entry in this table. Each language that is supported by the Clinical Browser has a column in this table. At run-time, the web server translates the literals into the appropriate language based upon a registry entry on the server.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_translate';

