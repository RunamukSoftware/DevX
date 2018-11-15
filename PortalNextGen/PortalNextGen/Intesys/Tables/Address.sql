CREATE TABLE [Intesys].[Address] (
    [AddressID]           INT           IDENTITY (1, 1) NOT NULL,
    [AddressLocationCode] NCHAR (1)     NOT NULL,
    [AddressTypeCode]     NCHAR (1)     NOT NULL,
    [ActiveSwitch]        BIT           NOT NULL,
    [OriginalPatientID]   INT           NULL,
    [Line1Description]    NVARCHAR (80) NULL,
    [Line2Description]    NVARCHAR (80) NULL,
    [Line3Description]    NVARCHAR (80) NULL,
    [City]                NVARCHAR (30) NULL,
    [CountyCodeID]        INT           NULL,
    [StateCode]           NVARCHAR (3)  NULL,
    [CountryCodeID]       INT           NULL,
    [PostalCode]          NVARCHAR (15) NULL,
    [StartDateTime]       DATETIME2 (7) NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_Address_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED ([AddressID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Address_AddressID_AddressLocationCode_AddressTypeCode]
    ON [Intesys].[Address]([AddressID] ASC, [AddressLocationCode] ASC, [AddressTypeCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Store addresses for patients, Next Of Kin''s, guarantors, external organizations, etc. Any/all addresses stored for entities are stored in this table. The PK of this table is always a FK to another entity (such as the patient or organization). There really isn''t a way to go "out" from this table and determine what the address is for (i.e. it is not easy to determine what is the parent of any given address). Normal access is always from the "owner" record to the address(es).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The associated person, Next Of Kin, organization, etc. This is a FK to either the person/patient table, external_organization, Next Of Kin, etc. table. It is not easy to trace back who the owner for a given address is (because it could reside in one of several tables).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'AddressID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the Type of ADDRESS (business or residential) for this occurrence.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'AddressLocationCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the category of the ADDRESS being described (e.g. billing, Mailing, Temporary, etc.). For Billing information, this value is routing information between the bill and the ENTITY.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'AddressTypeCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether an address is active or not.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'ActiveSwitch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient ID (if linked). Used by MPI logic to "unlink" a patient if necessary.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description that identifies the line of an address. First line of the address.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'Line1Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description that identifies the line of an address. Second line of the address.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'Line2Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description that identifies the line of an address. Third line of the address.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'Line3Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A name of a city that identifies where the ADDRESS is located.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code of the county that identifies where the ADDRESS is located. A CodeID that references a code for the county where the ADDRESS is located, if null the ADDRESS This is a FK to the MISC_CODE table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'CountyCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The common postal authority approved code that represents the state or province where the address exists. This field is not a CodeID since these codes are issued by the government or the region and generally do not change.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'StateCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A name of the country that identifies where the ADDRESS is located. This is a FK to the MISC_CODE table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'CountryCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the postal/area code.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'PostalCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'When this data became active (i.e. when the data became valid for the given patient, etc).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'StartDateTime';

