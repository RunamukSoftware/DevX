CREATE TABLE [Intesys].[Person] (
    [PersonID]         INT           IDENTITY (1, 1) NOT NULL,
    [NewPatientID]     INT           NULL,
    [FirstName]        NVARCHAR (50) NULL,
    [MiddleName]       NVARCHAR (50) NULL,
    [LastName]         NVARCHAR (50) NULL,
    [Suffix]           NVARCHAR (5)  NULL,
    [TelephoneNumber]  NVARCHAR (40) NULL,
    [Line1Description] NVARCHAR (80) NULL,
    [Line2Description] NVARCHAR (80) NULL,
    [Line3Description] NVARCHAR (80) NULL,
    [City]             NVARCHAR (30) NULL,
    [StateCode]        NVARCHAR (3)  NULL,
    [ZipCode]          NVARCHAR (15) NULL,
    [CountryCodeID]    INT           NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_Person_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Person_PersonID] PRIMARY KEY CLUSTERED ([PersonID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_Person_PersonID_FirstName_LastName]
    ON [Intesys].[Person]([PersonID] ASC)
    INCLUDE([FirstName], [LastName]) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Person_PersonID]
    ON [Intesys].[Person]([PersonID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores information that is common to certain types of people in the database. This includes patients, guarantors, Next Of Kin''s. It does NOT have entries for users (even though they are people). This table only contains attributes (columns) for data that is likely to available for Next Of Kin''s, guarantor''s, etc. Data that is generally only known for patients is in the int_patient table. A person''s current/primary name, telephone and address is de-normalized into this table for quick access. However, all names, addresses, and phone number''s are available in the int_address, int_telephone and int_person_name tables.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Person';

