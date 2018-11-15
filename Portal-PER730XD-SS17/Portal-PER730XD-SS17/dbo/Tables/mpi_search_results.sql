CREATE TABLE [dbo].[mpi_search_results] (
    [spid]      INT              NULL,
    [person_id] UNIQUEIDENTIFIER NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'mpi_search_results';

