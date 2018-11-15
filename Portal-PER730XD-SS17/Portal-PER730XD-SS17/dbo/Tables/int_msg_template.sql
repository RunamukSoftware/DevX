CREATE TABLE [dbo].[int_msg_template] (
    [msg_template_id] INT            NOT NULL,
    [msg_text]        NVARCHAR (255) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_msg_template_msg_template_id]
    ON [dbo].[int_msg_template]([msg_template_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the "template" for all error/warning messages displayed to the user. The DataLoader and communicator will report any warnings or errors using this template. Parameters to the message can be passed and substituted anywere in the message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_msg_template';

