CREATE TABLE [Intesys].[TestGroup] (
    [TestGroupID]     INT           IDENTITY (1, 1) NOT NULL,
    [NodeID]          INT           NOT NULL,
    [Rank]            INT           NOT NULL,
    [DisplayInAll]    TINYINT       NOT NULL,
    [ParentNodeID]    INT           NOT NULL,
    [DisplayType]     CHAR (5)      NOT NULL,
    [NodeName]        NVARCHAR (80) NOT NULL,
    [ParameterString] NVARCHAR (80) NOT NULL,
    [DisplayInMenu]   TINYINT       NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_TestGroup_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TestGroup_TestGroupID] PRIMARY KEY CLUSTERED ([TestGroupID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TestGroup_NodeID]
    ON [Intesys].[TestGroup]([NodeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the display structure of the test hierarchy on the result screen. The test results can be grouped together in a tree Type of display structure and each row of this table defines a non-leaf node in the tree display structure. The leaf node information is stored in test_group_detail table. Typically a nonleaf node in the tree is a Department (e.g.. LAB,RAD,ECG,..etc) or a Group (e.g.. Common Chemistry,XRAY etc) A leaf node will be the actual result test code or a universal service code (K-Sodium, NA-Potassium, Albumin, CHEM23 etc.) An example result display structure is: LAB test_group Common Chemistry test_group K test_group_detail NA test_group_detail ALBUMIN test_group_detail CHEM23 test_group_detail Specific Chemistry test_group A test_group_detail B test_group_detail RAD test_group XRAY test_group Chest x-ray test_group_detail', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TestGroup';

