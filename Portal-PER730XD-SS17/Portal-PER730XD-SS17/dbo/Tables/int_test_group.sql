CREATE TABLE [dbo].[int_test_group] (
    [node_id]         INT           NOT NULL,
    [rank]            INT           NOT NULL,
    [display_in_all]  TINYINT       NULL,
    [parent_node_id]  INT           NULL,
    [display_type]    CHAR (5)      NULL,
    [node_name]       NVARCHAR (80) NOT NULL,
    [parm_str]        NVARCHAR (80) NULL,
    [display_in_menu] TINYINT       NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_test_group_node_id]
    ON [dbo].[int_test_group]([node_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the display structure of the test hierarchy on the result screen. The test results can be grouped together in a tree type of display structure and each row of this table defines a non-leaf node in the tree display structure. The leaf node information is stored in test_group_detail table. Typically a nonleaf node in the tree is a Department (e.g.. LAB,RAD,ECG,..etc) or a Group (e.g.. Common Chemistry,XRAY etc) A leaf node will be the actual result test code or a universal service code (K-Sodium, NA-Potassium, Albumin, CHEM23 etc.) An example result display structure is: LAB test_group Common Chemistry test_group K test_group_detail NA test_group_detail ALBUMIN test_group_detail CHEM23 test_group_detail Specific Chemistry test_group A test_group_detail B test_group_detail RAD test_group XRAY test_group Chest x-ray test_group_detail', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_test_group';

