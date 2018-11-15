CREATE TABLE [dbo].[int_person_name] (
    [person_nm_id]    UNIQUEIDENTIFIER NOT NULL,
    [recognize_nm_cd] CHAR (2)         NOT NULL,
    [seq_no]          INT              NOT NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [active_sw]       TINYINT          NOT NULL,
    [prefix]          NVARCHAR (4)     NULL,
    [first_nm]        NVARCHAR (50)    NULL,
    [middle_nm]       NVARCHAR (50)    NULL,
    [last_nm]         NVARCHAR (50)    NULL,
    [suffix]          NVARCHAR (5)     NULL,
    [degree]          NVARCHAR (20)    NULL,
    [mpi_lname_cons]  NVARCHAR (20)    NULL,
    [mpi_fname_cons]  NVARCHAR (20)    NULL,
    [mpi_mname_cons]  NVARCHAR (20)    NULL,
    [start_dt]        DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_person_name_person_nm_id_recognize_nm_cd_seq_no_active_sw]
    ON [dbo].[int_person_name]([person_nm_id] ASC, [recognize_nm_cd] ASC, [seq_no] ASC, [active_sw] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all names.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_person_name';

