CREATE TABLE [CDR].[RestrictedOrganization] (
    [RestrictedOrganizationID] INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]           INT           NOT NULL,
    [RoleID]                   INT           NOT NULL,
    [CreatedDateTime]          DATETIME2 (7) CONSTRAINT [DF_RestrictedOrganization_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_RestrictedOrganization_RestrictedOrganizationID] PRIMARY KEY CLUSTERED ([RestrictedOrganizationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_RestrictedOrganization_Role_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [User].[Role] ([RoleID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_RestrictedOrganization_OrganizationID_UserRoleID]
    ON [CDR].[RestrictedOrganization]([OrganizationID] ASC, [RoleID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The RESTRICTED_ORGANIZATION table identifies Nursing Units whose patient related information is secured from the general user population. The users under the given user category id are not allowed to access the patients in the given department code (unless they are given ability to view patients on restricted units).', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'RestrictedOrganization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The id of the unit which is restricted for given user_categoryID. FK to ORGANIZATION', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'RestrictedOrganization', @level2type = N'COLUMN', @level2name = N'OrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'User category id restricted in the given unit.', @level0type = N'SCHEMA', @level0name = N'CDR', @level1type = N'TABLE', @level1name = N'RestrictedOrganization', @level2type = N'COLUMN', @level2name = N'RoleID';

