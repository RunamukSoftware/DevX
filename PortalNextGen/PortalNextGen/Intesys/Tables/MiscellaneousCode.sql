CREATE TABLE [Intesys].[MiscellaneousCode] (
    [MiscellaneousCodeID] INT            IDENTITY (1, 1) NOT NULL,
    [CodeID]              INT            NOT NULL,
    [OrganizationID]      INT            NOT NULL,
    [SystemID]            INT            NOT NULL,
    [CategoryCode]        CHAR (4)       NOT NULL,
    [MethodCode]          NVARCHAR (10)  NOT NULL,
    [Code]                NVARCHAR (80)  NOT NULL,
    [VerificationSwitch]  BIT            NOT NULL,
    [KeystoneCode]        NVARCHAR (80)  NOT NULL,
    [ShortDescription]    NVARCHAR (100) NOT NULL,
    [spc_pcs_code]        CHAR (1)       NOT NULL,
    [CreatedDateTime]     DATETIME2 (7)  CONSTRAINT [DF_MiscellaneousCode_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MiscellaneousCode_MiscellaneousCodeID] PRIMARY KEY CLUSTERED ([MiscellaneousCodeID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_MiscellaneousCode_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID])
);


GO
CREATE NONCLUSTERED INDEX [IX_MiscellaneousCode_ShortDescription_Code_KeystoneCode]
    ON [Intesys].[MiscellaneousCode]([ShortDescription] ASC, [Code] ASC, [KeystoneCode] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_MiscellaneousCode_Code_ShortDescription_KeystoneCode]
    ON [Intesys].[MiscellaneousCode]([Code] ASC, [ShortDescription] ASC, [KeystoneCode] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MiscellaneousCode_CategoryCode_Code_OrganizationID_SystemID_MethodCode]
    ON [Intesys].[MiscellaneousCode]([CategoryCode] ASC, [Code] ASC, [OrganizationID] ASC, [SystemID] ASC, [MethodCode] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MiscellaneousCode_CodeID]
    ON [Intesys].[MiscellaneousCode]([CodeID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_MiscellaneousCode_SystemID_MethodCode_OrganizationID_CodeID_CategoryCode_Code_ShortDescription]
    ON [Intesys].[MiscellaneousCode]([SystemID] ASC, [MethodCode] ASC, [OrganizationID] ASC)
    INCLUDE([CodeID], [CategoryCode], [Code], [ShortDescription]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores multiple code sets (miscellaneous codes). It stores many of the codified fields that HL/7 defines. All of these codes can be dynamically added by the back-end (DataLoader). However to ensure good descriptions of the code (for display), it is necessary for the administrator to update these dynamically added codes. Codes are unique for a given organization, feeder system and category (cat_code).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'MiscellaneousCode';

