CREATE TABLE [dbo].[cdr_restricted_organization] (
    [organization_id] UNIQUEIDENTIFIER NOT NULL,
    [user_role_id]    UNIQUEIDENTIFIER NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [restricted_organization_idx]
    ON [dbo].[cdr_restricted_organization]([organization_id] ASC, [user_role_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The RESTRICTED_ORGANIZATION table identifies Nursing Units whose patient related information is secured from the general user population. The users under the given user category id are not allowed to access the patients in the given department code (unless they are given ability to view patients on restricted units).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_restricted_organization';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The id of the unit which is restricted for given user_category_id. FK to ORGANIZATION', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_restricted_organization', @level2type = N'COLUMN', @level2name = N'organization_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'User category id restricted in the given unit.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdr_restricted_organization', @level2type = N'COLUMN', @level2name = N'user_role_id';

