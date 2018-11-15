CREATE TABLE [dbo].[mpi_patient_link] (
    [orig_patient_id] UNIQUEIDENTIFIER NOT NULL,
    [new_patient_id]  UNIQUEIDENTIFIER NOT NULL,
    [user_id]         UNIQUEIDENTIFIER NULL,
    [mod_dt]          DATETIME         NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [mpi_patient_link_orig_patient_id_new_patient_id]
    ON [dbo].[mpi_patient_link]([orig_patient_id] ASC, [new_patient_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to track patients that have been linked (i.e. are really the same patient). For a lot of reasons, a patient may have multiple patient records. Linking allows these duplicate records to be merged in such a way that allows them to later be "unlinked".', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'mpi_patient_link';

