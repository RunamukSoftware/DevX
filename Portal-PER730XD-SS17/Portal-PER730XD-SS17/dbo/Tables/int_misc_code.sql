CREATE TABLE [dbo].[int_misc_code] (
    [code_id]         INT              NOT NULL,
    [organization_id] UNIQUEIDENTIFIER NULL,
    [sys_id]          UNIQUEIDENTIFIER NULL,
    [category_cd]     CHAR (4)         NULL,
    [method_cd]       NVARCHAR (10)    NULL,
    [code]            NVARCHAR (80)    NULL,
    [verification_sw] TINYINT          NULL,
    [int_keystone_cd] NVARCHAR (80)    NULL,
    [short_dsc]       NVARCHAR (100)   NULL,
    [spc_pcs_code]    CHAR (1)         NULL
);




GO

GO

GO

GO
CREATE NONCLUSTERED INDEX [IX_int_misc_code_short_dsc_code_int_keystone_cd]
    ON [dbo].[int_misc_code]([short_dsc] ASC, [code] ASC, [int_keystone_cd] ASC) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores multiple code sets (miscellaneous codes). It stores many of the codified fields that HL/7 defines. All of these codes can be dynamically added by the back-end (DataLoader). However to ensure good descriptions of the code (for display), it is necessary for the administrator to update these dynamically added codes. Codes are unique for a given organization, feeder system and category (cat_code).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_misc_code';
GO

GO

GO

