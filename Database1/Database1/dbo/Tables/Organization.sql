CREATE TABLE [dbo].[Organization] (
    [OrganizationID]           INT          NOT NULL,
    [OrganizationNumber]       CHAR (10)    NOT NULL,
    [OrganizationName]         VARCHAR (50) NOT NULL,
    [ManagerID]                INT          NULL,
    [ParentOrganizationNumber] CHAR (10)    NULL,
    [Sequence]                 BIGINT       IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Organization_OrganizationID] PRIMARY KEY NONCLUSTERED ([OrganizationID] ASC)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

