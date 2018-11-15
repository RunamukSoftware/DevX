CREATE TABLE [dbo].[int_specimen_group] (
    [rank]           INT           NOT NULL,
    [source_cd]      NVARCHAR (30) NULL,
    [specimen_group] NVARCHAR (30) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_specimen_group_specimen_group]
    ON [dbo].[int_specimen_group]([specimen_group] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This entity type is used in the displaying and presentation of specimen information as it relates to a specific result. One of the functions of this entity type is to optionally allow an entry for no specimen type so it can be mapped to a group. It also defines a standard method to map multiple specimen types to one code. The short description of the code we map to will then be used for display. If a specific value is not sent, default back to the specimen code. ''DEFAULT'' should not be an allowable specimen type or specimen group because it is a potential entry in the TGM with specific functionality associated. This table is not currently used in the CDR.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_specimen_group';

