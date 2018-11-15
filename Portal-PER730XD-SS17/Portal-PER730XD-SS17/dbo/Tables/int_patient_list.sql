CREATE TABLE [dbo].[int_patient_list] (
    [patient_list_id] UNIQUEIDENTIFIER NOT NULL,
    [owner_id]        UNIQUEIDENTIFIER NULL,
    [type_cd]         CHAR (3)         NOT NULL,
    [list_name]       NVARCHAR (30)    NULL,
    [svc_cid]         INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_patient_list_patient_list_id]
    ON [dbo].[int_patient_list]([patient_list_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is the "master" list for the patient lists. It contains an entry for each list (not for each entry on those lists). The detail of which patients belong on the list is contained in int_patient_list_detail. A patient list is any logical collection of patients that can not be generated quickly enough through a direct query from other tables. It is also sometimes under the user control (for example user lists that the user can add/remove patients manually to). Other lists are system maintained by "events" such as admits/discharges (like practicing lists).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient_list';

