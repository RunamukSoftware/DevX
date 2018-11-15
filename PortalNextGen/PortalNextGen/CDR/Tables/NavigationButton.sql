CREATE TABLE [CDR].[NavigationButton] (
    [NavigationButtonID] INT           IDENTITY (1, 1) NOT NULL,
    [Description]        NVARCHAR (80) NOT NULL,
    [ImageIndex]         INT           NULL,
    [Position]           INT           NOT NULL,
    [FormName]           VARCHAR (255) NOT NULL,
    [NodeID]             INT           NULL,
    [Shortcut]           NCHAR (1)     NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_NavigationButton_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_NavigationButton_NavigationButtonID] PRIMARY KEY CLUSTERED ([NavigationButtonID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NavigationButton_Description_Position_FormName_NodeID]
    ON [CDR].[NavigationButton]([Description] ASC, [Position] ASC, [FormName] ASC, [NodeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table holds the information about the navigation buttons for the front end application. This includes the color, image, whether it is visible or not and what form name is associated with the button.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Text to be displayed on button', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Index to button image list which tells which image to display on button', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton', @level2type = N'COLUMN', @level2name = N'ImageIndex';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order of the button on screen (1,2,3..) 1 is the first button on the left side of the screen.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton', @level2type = N'COLUMN', @level2name = N'Position';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name of form to display if button clicked', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton', @level2type = N'COLUMN', @level2name = N'FormName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to TEST_GROUP. if form is a result screen, the NodeID of result to display.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton', @level2type = N'COLUMN', @level2name = N'NodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Short cut key for the button', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'NavigationButton', @level2type = N'COLUMN', @level2name = N'Shortcut';

