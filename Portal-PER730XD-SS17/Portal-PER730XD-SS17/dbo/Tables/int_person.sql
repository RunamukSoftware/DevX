CREATE TABLE [dbo].[int_person] (
    [person_id]      UNIQUEIDENTIFIER NOT NULL,
    [new_patient_id] UNIQUEIDENTIFIER NULL,
    [first_nm]       NVARCHAR (50)    NULL,
    [middle_nm]      NVARCHAR (50)    NULL,
    [last_nm]        NVARCHAR (50)    NULL,
    [suffix]         NVARCHAR (5)     NULL,
    [tel_no]         NVARCHAR (40)    NULL,
    [line1_dsc]      NVARCHAR (80)    NULL,
    [line2_dsc]      NVARCHAR (80)    NULL,
    [line3_dsc]      NVARCHAR (80)    NULL,
    [city_nm]        NVARCHAR (30)    NULL,
    [state_code]     NVARCHAR (3)     NULL,
    [zip_code]       NVARCHAR (15)    NULL,
    [country_cid]    INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_person_person_id]
    ON [dbo].[int_person]([person_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores information that is common to certain types of people in the database. This includes patients, gurantors, NOK''s. It does NOT have entries for users (even though they are people). This table only contains attributes (columns) for data that is likely to available for NOK''s, guarantor''s, etc. Data that is generally only known for patients is in the int_patient table. A person''s current/primary name, telephone and address is de-normalized into this table for quick access. However, all names, addresses, and phone #''s are available in the int_address, int_telephone and int_person_name tables.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_person';

