CREATE TABLE [dbo].[cdr_navigation_button] (
    [descr]       NVARCHAR (80) NOT NULL,
    [image_index] INT           NULL,
    [position]    INT           NOT NULL,
    [form_name]   VARCHAR (255) NOT NULL,
    [node_id]     INT           NULL,
    [shortcut]    NCHAR (1)     NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_cdr_navigation_button_descr_position_form_name_node_id]
    ON [dbo].[cdr_navigation_button]([descr] ASC, [position] ASC, [form_name] ASC, [node_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table holds the information about the navigation buttons for the front end application. This includes the color, image, whether it is visible or not and what form name is associated with the button.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Text to be displayed on button', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button', @level2type = N'COLUMN', @level2name = N'descr';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Index to button image list which tells which image to display on button', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button', @level2type = N'COLUMN', @level2name = N'image_index';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order of the button on screen (1,2,3..) 1 is the first button on the left side of the screen.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button', @level2type = N'COLUMN', @level2name = N'position';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name of form to display if button clicked', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button', @level2type = N'COLUMN', @level2name = N'form_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to TEST_GROUP. if form is a result screen, the node_id of result to display.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button', @level2type = N'COLUMN', @level2name = N'node_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Short cut key for the button', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_navigation_button', @level2type = N'COLUMN', @level2name = N'shortcut';

