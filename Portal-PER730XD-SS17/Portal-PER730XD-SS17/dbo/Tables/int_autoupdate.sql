CREATE TABLE [dbo].[int_autoupdate] (
    [prod]     CHAR (3)      NULL,
    [seq]      INT           NULL,
    [action]   VARCHAR (255) NOT NULL,
    [disabled] TINYINT       NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_autoupdate_seq_prod]
    ON [dbo].[int_autoupdate]([seq] ASC, [prod] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains update information read by the autoupdate service that is then sent out to each client on demand. Each product has update actions that are in order by sequence. When a client want the first update action for CDR, he asks for CDR update 0. When the update action completes successfully, update 1 is next....', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product for auto update like CDR, CPI, ... Field 2 of primary key.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate', @level2type = N'COLUMN', @level2name = N'prod';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequences the autoupdate actions  Field 1 of primary key.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate', @level2type = N'COLUMN', @level2name = N'seq';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The actual action text to perform. Some examples are: download,cowboys,jeffk,horse,Setup.exe,/cdrversions/5.10.14,$carewindows" downloadrun,cowboys,jeffk,horse,Setup.exe,/cdrversions/5.10.14,$temp" regfile,cowboys,jeffk,horse,Reg1.Reg,/RegFiles,$temp" ReplaceSelf,cowboys,jeffk,horse,/AutoUpdater" regfile,cowboys,jeffk,horse,chgtime.reg,/Regfiles,$temp" message,300,Carewindows will exit in 10 seconds to be replaced with a new version" kill,carewindows" download,cowboys,jeffk,horse,carewindows.exe,/cdrversions/jefftest,$CAREWINDOWS" run,False,$CAREWINDOWS,carewindows.exe" run,False,$CAREWINDOWS,cwcfg.exe" download,cowboys,jeffk,horse,carewindows.exe,/carewindows/55,$carewindows"', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate', @level2type = N'COLUMN', @level2name = N'action';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NULL or zero if you want to have the autoupdate server tell the clients to skip over updating this action. Instead of sending the acton text associated with the aciton, autoupdate server just sends NOP if disabled is greater than zero.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate', @level2type = N'COLUMN', @level2name = N'disabled';

