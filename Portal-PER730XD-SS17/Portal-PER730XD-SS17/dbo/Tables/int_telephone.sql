CREATE TABLE [dbo].[int_telephone] (
    [phone_id]        UNIQUEIDENTIFIER NOT NULL,
    [phone_loc_cd]    CHAR (1)         NOT NULL,
    [phone_type_cd]   CHAR (1)         NOT NULL,
    [seq_no]          INT              NOT NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [active_sw]       TINYINT          NOT NULL,
    [tel_no]          NVARCHAR (40)    NULL,
    [ext_no]          NVARCHAR (12)    NULL,
    [areacode]        NVARCHAR (3)     NULL,
    [mpi_tel1]        SMALLINT         NULL,
    [mpi_tel2]        SMALLINT         NULL,
    [mpi_tel3]        SMALLINT         NULL,
    [start_dt]        DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_telephone_phone_id_phone_loc_cd_phone_type_cd_seq_no]
    ON [dbo].[int_telephone]([phone_id] ASC, [phone_loc_cd] ASC, [phone_type_cd] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores ALL telephone numbers for patients, NOK''s, guarantor''s, external organizations, etc. While the current/primary phone # for a patient is de-normalized into the int_person table for performance reasons, all current and historical phone #''s are in this table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_telephone';

