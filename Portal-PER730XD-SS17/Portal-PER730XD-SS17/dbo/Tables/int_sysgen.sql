CREATE TABLE [dbo].[int_sysgen] (
    [Sequence]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [product_cd] VARCHAR (25) NOT NULL,
    [feature_cd] VARCHAR (25) NOT NULL,
    [setting]    VARCHAR (80) NULL,
    CONSTRAINT [PK_int_sysgen_Sequence] PRIMARY KEY NONCLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the system generation information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_sysgen';

