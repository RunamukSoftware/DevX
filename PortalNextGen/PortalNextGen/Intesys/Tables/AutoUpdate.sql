CREATE TABLE [Intesys].[AutoUpdate] (
    [AutoUpdateID]    INT           IDENTITY (1, 1) NOT NULL,
    [Product]         CHAR (3)      NULL,
    [Sequence]        INT           NULL,
    [Action]          VARCHAR (255) NOT NULL,
    [Disabled]        TINYINT       NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_AutoUpdate_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AutoUpdate_AutoUpdateID] PRIMARY KEY CLUSTERED ([AutoUpdateID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AutoUpdate_Sequence_Prod]
    ON [Intesys].[AutoUpdate]([Sequence] ASC, [Product] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains update information read by the autoupdate service that is then sent out to each client on demand. Each product has update actions that are in order by sequence. When a client want the first update action for CDR, he asks for CDR update 0. When the update action completes successfully, update 1 is next....', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product for auto update like CDR, CPI, ... Field 2 of primary key.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdate', @level2type = N'COLUMN', @level2name = N'Product';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequences the autoupdate actions  Field 1 of primary key.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdate', @level2type = N'COLUMN', @level2name = N'Sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The actual action text to perform. Some examples are: download,cowboys,jeffk,horse,Setup.exe,/cdrversions/5.10.14,$carewindows" downloadrun,cowboys,jeffk,horse,Setup.exe,/cdrversions/5.10.14,$temp" regfile,cowboys,jeffk,horse,Reg1.Reg,/RegFiles,$temp" ReplaceSelf,cowboys,jeffk,horse,/AutoUpdater" regfile,cowboys,jeffk,horse,chgtime.reg,/Regfiles,$temp" message,300,Carewindows will exit in 10 seconds to be replaced with a new version" kill,carewindows" download,cowboys,jeffk,horse,carewindows.exe,/cdrversions/jefftest,$CAREWINDOWS" run,False,$CAREWINDOWS,carewindows.exe" run,False,$CAREWINDOWS,cwcfg.exe" download,cowboys,jeffk,horse,carewindows.exe,/carewindows/55,$carewindows"', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdate', @level2type = N'COLUMN', @level2name = N'Action';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NULL or zero if you want to have the autoupdate server tell the clients to skip over updating this action. Instead of sending the acton text associated with the aciton, autoupdate server just sends NOP if disabled is greater than zero.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdate', @level2type = N'COLUMN', @level2name = N'Disabled';

