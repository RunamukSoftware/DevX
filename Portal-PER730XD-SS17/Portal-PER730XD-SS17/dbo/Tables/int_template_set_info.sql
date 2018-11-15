CREATE TABLE [dbo].[int_template_set_info] (
    [user_id]             UNIQUEIDENTIFIER NOT NULL,
    [patient_id]          UNIQUEIDENTIFIER NOT NULL,
    [template_set_index]  INT              NOT NULL,
    [lead_one]            INT              NOT NULL,
    [lead_two]            INT              NOT NULL,
    [number_of_bins]      INT              NOT NULL,
    [number_of_templates] INT              NOT NULL,
    CONSTRAINT [PK_int_template_set_info_user_id_patient_id_template_set_index] PRIMARY KEY CLUSTERED ([user_id] ASC, [patient_id] ASC, [template_set_index] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_template_set_info_AnalysisTime_user_id_patient_id] FOREIGN KEY ([user_id], [patient_id]) REFERENCES [dbo].[AnalysisTime] ([user_id], [patient_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains template set information. Can have up to 4 template sets per user/patient analysis.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_template_set_info';

