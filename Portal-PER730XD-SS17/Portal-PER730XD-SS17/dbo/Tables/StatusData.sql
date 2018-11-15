CREATE TABLE [dbo].[StatusData]
    ([Id] UNIQUEIDENTIFIER NOT NULL,
     [SetId] UNIQUEIDENTIFIER NOT NULL,
     [Name] VARCHAR(25) NOT NULL,
     [Value] VARCHAR(25) NULL,
     [Sequence] BIGINT IDENTITY(-9223372036854775808, 1) NOT NULL,
     CONSTRAINT [PK_StatusData_Sequence]
         PRIMARY KEY CLUSTERED ([Sequence] ASC)
         WITH (FILLFACTOR = 100));
GO
CREATE NONCLUSTERED INDEX [IX_StatusData_SetId]
ON [dbo].[StatusData] ([SetId] ASC)
WITH (FILLFACTOR = 100);
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Status Data',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'StatusData';
