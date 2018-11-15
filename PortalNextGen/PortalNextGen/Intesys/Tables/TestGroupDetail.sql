CREATE TABLE [Intesys].[TestGroupDetail] (
    [TestGroupDetailID]   INT           IDENTITY (1, 1) NOT NULL,
    [NodeID]              INT           NOT NULL,
    [TestCodeID]          INT           NULL,
    [univwsvcCodeID]      INT           NULL,
    [Rank]                INT           NOT NULL,
    [DisplayType]         CHAR (5)      NULL,
    [Name]                NVARCHAR (80) NOT NULL,
    [SourceCodeID]        INT           NULL,
    [AliasTestCodeID]     INT           NULL,
    [AliasUnivwsvcCodeID] INT           NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_TestGroupDetail_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TestGroupDetail_TestGroupDetailID] PRIMARY KEY CLUSTERED ([TestGroupDetailID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TestGroupDetail_NodeID_TestCodeID_univwsvcCodeID_Rank]
    ON [Intesys].[TestGroupDetail]([NodeID] ASC, [TestCodeID] ASC, [univwsvcCodeID] ASC, [Rank] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TestGroupDetail_TestCodeID_univwsvcCodeID_NodeID_SourceCodeID]
    ON [Intesys].[TestGroupDetail]([TestCodeID] ASC, [univwsvcCodeID] ASC, [NodeID] ASC, [SourceCodeID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the leaf nodes of the display structure of the test hierarchy on the result screen. The test results can be grouped together in a tree Type of display structure and each row of the test_group table defines a non-leaf node in the tree display structure. The leaf node information is stored in test_group_detail table. Typically a non-leaf node in the tree is a Department (e.g.. LAB,RAD,ECG,..etc) or a Group (e.g.. CommonChemistry,X=RAY etc) A leaf node will be the actual result test code or a universal service code (K-Sodium, NA-Potassium, Albumin, CHEM23 etc.) An example result display structure is: LAB test_group Common Chemistry test_group K test_group_detail NA test_group_detail ALBUMIN test_group_detail CHEM23 test_group_detail Specific Chemistry test_group A test_group_detail B test_group_detail RAD test_group XRAY test_group Chest x-ray test_group_detail', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TestGroupDetail';

