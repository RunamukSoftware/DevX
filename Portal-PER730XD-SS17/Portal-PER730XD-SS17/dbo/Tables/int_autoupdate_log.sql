CREATE TABLE [dbo].[int_autoupdate_log] (
    [machine]   NVARCHAR (50) NOT NULL,
    [action_dt] DATETIME      NOT NULL,
    [prod]      CHAR (3)      NOT NULL,
    [success]   TINYINT       NOT NULL,
    [reason]    NVARCHAR (80) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_autoupdate_log_machine_action_dt_prod]
    ON [dbo].[int_autoupdate_log]([machine] ASC, [action_dt] ASC, [prod] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table logs all successful and unsuccessful autoupdate attempts. Each client sends either an ACK or a NACK to the service, and the service then puts the appropriate row in the database. The intention is to use the OCX I wrote which views the log within MMC to have a realtime viewer of system updates.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate_log';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP address or NT network name of machine that update was for.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate_log', @level2type = N'COLUMN', @level2name = N'machine';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date action was applied to machine', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate_log', @level2type = N'COLUMN', @level2name = N'action_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product that action applied to like CDR, CPI, ...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate_log', @level2type = N'COLUMN', @level2name = N'prod';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 if action was ACKed 0 if action was NACKed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate_log', @level2type = N'COLUMN', @level2name = N'success';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains the error text passed from the client of action failed to be applied to that client. Example : Couldnt overwrite file Carewindow.exe, file in use.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_autoupdate_log', @level2type = N'COLUMN', @level2name = N'reason';

