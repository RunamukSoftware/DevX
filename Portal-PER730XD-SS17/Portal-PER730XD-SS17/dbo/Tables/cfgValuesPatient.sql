CREATE TABLE [dbo].[cfgValuesPatient] (
    [patient_id]    UNIQUEIDENTIFIER    NOT NULL,
    [type_cd]       VARCHAR (25)        NOT NULL,
    [cfg_name]      VARCHAR (40)        NOT NULL,
    [cfg_value]     [dbo].[DCFG_VALUES] NULL,
    [cfg_xml_value] XML                 NULL,
    [value_type]    VARCHAR (20)        NOT NULL,
    [timestamp]     DATETIME            CONSTRAINT [DEF_cfgValuesPatient_timestamp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ValuesPatientConst_patient_id_type_cd_cfg_name] PRIMARY KEY CLUSTERED ([patient_id] ASC, [type_cd] ASC, [cfg_name] ASC) WITH (FILLFACTOR = 100)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains CH patient settings (gets populated if user goes into CH and modifies settings). type_cd, cfg_name, and patient_id should be PKs.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cfgValuesPatient';


GO
CREATE NONCLUSTERED INDEX [IX_cfgValuesPatient_timestamp_patient_id_type_cd_cfg_name]
    ON [dbo].[cfgValuesPatient]([timestamp] ASC)
    INCLUDE([patient_id], [type_cd], [cfg_name]);

