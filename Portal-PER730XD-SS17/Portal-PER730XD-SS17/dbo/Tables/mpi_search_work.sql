CREATE TABLE [dbo].[mpi_search_work] (
    [spid]      INT              NULL,
    [person_id] UNIQUEIDENTIFIER NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Work table that is used when searching the master patient index for a patient. The rows in this table are deleted after the search is finished.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'mpi_search_work';

