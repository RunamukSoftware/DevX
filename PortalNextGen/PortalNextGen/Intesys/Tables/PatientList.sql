CREATE TABLE [Intesys].[PatientList] (
    [PatientListID]   INT           IDENTITY (1, 1) NOT NULL,
    [OwnerID]         INT           NOT NULL,
    [TypeCode]        CHAR (3)      NOT NULL,
    [list_name]       NVARCHAR (30) NOT NULL,
    [ServiceCodeID]   INT           NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_PatientList_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientList_PatientListID] PRIMARY KEY CLUSTERED ([PatientListID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientList_PatientList_PatientListID]
    ON [Intesys].[PatientList]([PatientListID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is the "master" list for the patient lists. It contains an entry for each list (not for each entry on those lists). The detail of which patients belong on the list is contained in int_patient_list_detail. A patient list is any logical collection of patients that can not be generated quickly enough through a direct query from other tables. It is also sometimes under the user control (for example user lists that the user can add/remove patients manually to). Other lists are system maintained by "events" such as admits/discharges (like practicing lists).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientList';

