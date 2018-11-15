CREATE TABLE [dbo].[int_broadcast_msg] (
    [timer_msg]         NVARCHAR (255) NULL,
    [login_msg]         NVARCHAR (255) NULL,
    [log_out_minutes]   INT            NULL,
    [keep_out]          INT            NULL,
    [disable_autoprocs] INT            NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The table is used to store the system broadcast message to be sent to users. It also contains a message to display to users on login. This table has at most 1 record in it (if there is any kind of message to display).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_broadcast_msg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Message to display to ALL users ASAP. Periodically, every Carewindow that is running checks this table for a message to display. This table has at most 1 record (or no records if there are no messages to display).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_broadcast_msg', @level2type = N'COLUMN', @level2name = N'timer_msg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A message to display to ALL users attempting to login to the CDR.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_broadcast_msg', @level2type = N'COLUMN', @level2name = N'login_msg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'How many minutes to wait before forcing ALL users to exit the CDR. If 0 then it will not force them out.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_broadcast_msg', @level2type = N'COLUMN', @level2name = N'log_out_minutes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether to keep ALL users from logging into the CDR.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_broadcast_msg', @level2type = N'COLUMN', @level2name = N'keep_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether to disable all automatic processes from running.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_broadcast_msg', @level2type = N'COLUMN', @level2name = N'disable_autoprocs';

