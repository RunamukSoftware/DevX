CREATE TABLE [dbo].[mpi_search_field] (
    [field_name]    NVARCHAR (30)  NOT NULL,
    [col_name]      NVARCHAR (30)  NULL,
    [low]           SMALLINT       NOT NULL,
    [high]          SMALLINT       NOT NULL,
    [compare_type]  NCHAR (30)     NULL,
    [code_category] NVARCHAR (4)   NULL,
    [is_secondary]  INT            NULL,
    [is_primary]    INT            NULL,
    [HL7_field]     NVARCHAR (100) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_mpi_search_field_field_name]
    ON [dbo].[mpi_search_field]([field_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains all fields you can do a MPI search on. You can change the weights that control how important each field is in the search. This table is used in the MPI search (either by the end user or during the background MPI lookup).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'mpi_search_field';

