CREATE TABLE [dbo].[int_patient] (
    [patient_id]           UNIQUEIDENTIFIER NOT NULL,
    [new_patient_id]       UNIQUEIDENTIFIER NULL,
    [organ_donor_sw]       NCHAR (2)        NULL,
    [living_will_sw]       NCHAR (2)        NULL,
    [birth_order]          TINYINT          NULL,
    [veteran_status_cid]   INT              NULL,
    [birth_place]          NVARCHAR (50)    NULL,
    [ssn]                  NVARCHAR (15)    NULL,
    [mpi_ssn1]             INT              NULL,
    [mpi_ssn2]             INT              NULL,
    [mpi_ssn3]             INT              NULL,
    [mpi_ssn4]             INT              NULL,
    [driv_lic_no]          NVARCHAR (25)    NULL,
    [mpi_dl1]              NVARCHAR (3)     NULL,
    [mpi_dl2]              NVARCHAR (3)     NULL,
    [mpi_dl3]              NVARCHAR (3)     NULL,
    [mpi_dl4]              NVARCHAR (3)     NULL,
    [driv_lic_state_code]  NVARCHAR (3)     NULL,
    [dob]                  DATETIME         NULL,
    [death_dt]             DATETIME         NULL,
    [nationality_cid]      INT              NULL,
    [citizenship_cid]      INT              NULL,
    [ethnic_group_cid]     INT              NULL,
    [race_cid]             INT              NULL,
    [gender_cid]           INT              NULL,
    [primary_language_cid] INT              NULL,
    [marital_status_cid]   INT              NULL,
    [religion_cid]         INT              NULL,
    [monitor_interval]     INT              NULL,
    [height]               FLOAT (53)       NULL,
    [weight]               FLOAT (53)       NULL,
    [bsa]                  FLOAT (53)       NULL,
    CONSTRAINT [PK_int_patient_patient_id] PRIMARY KEY CLUSTERED ([patient_id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores each patient record. Every patient is assigned a unique internal ID (GUID) that can never be duplicated. This table also has MPI specific fields used by the MPI engine to ensure that patients are not duplicated because of minor data-entry errors.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient';

