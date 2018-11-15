CREATE TABLE [dbo].[int_address] (
    [address_id]      UNIQUEIDENTIFIER NOT NULL,
    [addr_loc_cd]     NCHAR (1)        NOT NULL,
    [addr_type_cd]    NCHAR (1)        NOT NULL,
    [seq_no]          INT              NOT NULL,
    [active_sw]       TINYINT          NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [line1_dsc]       NVARCHAR (80)    NULL,
    [line2_dsc]       NVARCHAR (80)    NULL,
    [line3_dsc]       NVARCHAR (80)    NULL,
    [city_nm]         NVARCHAR (30)    NULL,
    [county_cid]      INT              NULL,
    [state_code]      NVARCHAR (3)     NULL,
    [country_cid]     INT              NULL,
    [zip_code]        NVARCHAR (15)    NULL,
    [start_dt]        DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_address_address_id_addr_loc_cd_addr_type_cd_seq_no]
    ON [dbo].[int_address]([address_id] ASC, [addr_loc_cd] ASC, [addr_type_cd] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Store addresses for patients, NOK''s, guarantors, external organizations, etc. Any/all addresses stored for entities are stored in this table. The PK of this table is always a FK to another entity (such as the patient or organization). There really isn''t a way to go "out" from this table and determine what the address is for (i.e. it is not easy to determine what is the parent of any given address). Normal access is always from the "owner" record to the address(es).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The associated person, NOK, organization, etc. This is a FK to either the person/patient table, external_organization, NOK, etc. table. It is not easy to trace back who the owner for a given address is (because it could reside in one of several tables).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'address_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the type of ADDRESS (business or residential) for this occurrence.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'addr_loc_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the category of the ADDRESS being described (e.g. billing, Mailing, Temporary, etc.). For Billing information, this value is routing information between the bill and the ENTITY.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'addr_type_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the sequence or order of the ADDRESS. This allows multiple addresses of the same type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'seq_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates whether an address is active or not.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'active_sw';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient ID (if linked). Used by MPI logic to "unlink" a patient if necessary.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description that identifies the line of an ADDRESS. First line of the address.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'line1_dsc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description that identifies the line of an ADDRESS. Second line of the address.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'line2_dsc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description that identifies the line of an ADDRESS. Third line of the address.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'line3_dsc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A name of a city that identifies where the ADDRESS is located.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'city_nm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code of the county that identifies where the ADDRESS is located. A code_id that references a code for the county where the ADDRESS is located, if null the ADDRESS This is a FK to the MISC_CODE table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'county_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The common postal authority approved code that represents the state or province where the address exists. This field is not a code_id since these codes are issued by the government or the region and generally do not change.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'state_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A name of the country that identifies where the ADDRESS is located. This is a FK to the MISC_CODE table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'country_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the postal/area code.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'zip_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'When this data became active (i.e. when the data became valid for the given patient, etc).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_address', @level2type = N'COLUMN', @level2name = N'start_dt';

