CREATE TABLE [dbo].[int_test_group_detail] (
    [node_id]            INT           NOT NULL,
    [test_cid]           INT           NULL,
    [univ_svc_cid]       INT           NULL,
    [rank]               INT           NOT NULL,
    [display_type]       CHAR (5)      NULL,
    [nm]                 NVARCHAR (80) NOT NULL,
    [source_cid]         INT           NULL,
    [alias_test_cid]     INT           NULL,
    [alias_univ_svc_cid] INT           NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_test_group_detail_node_id_test_cid_univ_svc_cid_rank]
    ON [dbo].[int_test_group_detail]([node_id] ASC, [test_cid] ASC, [univ_svc_cid] ASC, [rank] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_test_group_detail_test_cid_univ_svc_cid_node_id_source_cid]
    ON [dbo].[int_test_group_detail]([test_cid] ASC, [univ_svc_cid] ASC, [node_id] ASC, [source_cid] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the leaf nodes of the display structure of the test hierarchy on the result screen. The test results can be grouped together in a tree type of display structure and each row of the test_group table defines a non-leaf node in the tree display structure. The leaf node information is stored in test_group_detail table. Typically a non-leaf node in the tree is a Department (e.g.. LAB,RAD,ECG,..etc) or a Group (e.g.. CommonChemistry,X=RAY etc) A leaf node will be the actual result test code or a universal service code (K-Sodium, NA-Potassium, Albumin, CHEM23 etc.) An example result display structure is: LAB test_group Common Chemistry test_group K test_group_detail NA test_group_detail ALBUMIN test_group_detail CHEM23 test_group_detail Specific Chemistry test_group A test_group_detail B test_group_detail RAD test_group XRAY test_group Chest x-ray test_group_detail', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_test_group_detail';

