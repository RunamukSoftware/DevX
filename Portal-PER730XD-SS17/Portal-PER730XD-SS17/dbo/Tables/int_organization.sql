CREATE TABLE [dbo].[int_organization] (
    [organization_id]        UNIQUEIDENTIFIER NOT NULL,
    [category_cd]            CHAR (1)         NULL,
    [parent_organization_id] UNIQUEIDENTIFIER NULL,
    [organization_cd]        NVARCHAR (180)   NULL,
    [organization_nm]        NVARCHAR (180)   NULL,
    [in_default_search]      TINYINT          NULL,
    [monitor_disable_sw]     TINYINT          NULL,
    [auto_collect_interval]  INT              NULL,
    [outbound_interval]      INT              NULL,
    [printer_name]           VARCHAR (255)    NULL,
    [alarm_printer_name]     VARCHAR (255)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_organization_organization_id]
    ON [dbo].[int_organization]([organization_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_organization_category_cd]
    ON [dbo].[int_organization]([category_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the organizational structure of the enterprise. It describes a "tree structure" which includes the organization, facilities and units. This table must be defined before HL7 messages are played in since Feeder systems are defined as part of each Facility.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_organization';

