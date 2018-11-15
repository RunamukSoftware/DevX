CREATE TABLE [User].[Group] (
    [GroupID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (10) NOT NULL,
    [Description]      NVARCHAR (50) NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_UserGroup_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedDateTime] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Group_GroupID] PRIMARY KEY CLUSTERED ([GroupID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Group_Name]
    ON [User].[Group]([Name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the groups that are available for user groups. Each user can be a member of zero, one or multiple user groups. Users are assigned to groups to allow coverage or access to the practicing lists of the other members in the group. It is used for any "clinical grouping" that needs to occur for each application and is somewhat application defined.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'TABLE', @level1name = N'Group';

