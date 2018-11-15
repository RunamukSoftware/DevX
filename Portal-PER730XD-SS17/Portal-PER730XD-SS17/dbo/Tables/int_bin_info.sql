CREATE TABLE [dbo].[int_bin_info] (
    [user_id]                UNIQUEIDENTIFIER NOT NULL,
    [patient_id]             UNIQUEIDENTIFIER NOT NULL,
    [template_set_index]     INT              NOT NULL,
    [template_index]         INT              NOT NULL,
    [bin_number]             INT              NOT NULL,
    [source]                 INT              NOT NULL,
    [beat_count]             INT              NOT NULL,
    [first_beat_number]      INT              NOT NULL,
    [non_ignored_count]      INT              NOT NULL,
    [first_non_ignored_beat] INT              NOT NULL,
    [iso_offset]             INT              NOT NULL,
    [st_offset]              INT              NOT NULL,
    [i_point]                INT              NOT NULL,
    [j_point]                INT              NOT NULL,
    [st_class]               INT              NOT NULL,
    [singles_bin]            INT              NOT NULL,
    [edit_bin]               INT              NOT NULL,
    [subclass_number]        INT              NOT NULL,
    [bin_image]              IMAGE            NULL,
    CONSTRAINT [PK_int_bin_info_user_id_patient_id_template_set_index_template_index] PRIMARY KEY CLUSTERED ([user_id] ASC, [patient_id] ASC, [template_set_index] ASC, [template_index] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_bin_info_int_template_set_info_user_id_patient_id_template_set_index] FOREIGN KEY ([user_id], [patient_id], [template_set_index]) REFERENCES [dbo].[int_template_set_info] ([user_id], [patient_id], [template_set_index]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains template/bin information. It contains 2 additional PKs:  template_set_index and template_index. The template_set_index column will refer back to a template set in the int_template_set_info table. This table will contain multiple rows per user/patient analysis (one row for each template). I think we should consider renaming it to int_template_info (or some variation of that).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_bin_info';

