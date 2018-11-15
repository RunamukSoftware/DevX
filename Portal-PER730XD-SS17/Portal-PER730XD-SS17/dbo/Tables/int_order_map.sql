CREATE TABLE [dbo].[int_order_map] (
    [order_id]        UNIQUEIDENTIFIER NOT NULL,
    [patient_id]      UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [organization_id] UNIQUEIDENTIFIER NOT NULL,
    [sys_id]          UNIQUEIDENTIFIER NOT NULL,
    [order_xid]       NVARCHAR (30)    NOT NULL,
    [type_cd]         CHAR (1)         NULL,
    [seq_no]          INT              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_order_map_patient_id_organization_id_sys_id_order_xid_type_cd_seq_no]
    ON [dbo].[int_order_map]([patient_id] ASC, [organization_id] ASC, [sys_id] ASC, [order_xid] ASC, [type_cd] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_order_map_order_id]
    ON [dbo].[int_order_map]([order_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table''s purpose is to take the ORGANZATION_ENTITY_ID, SYSTEM_ENTITY_ID, and ORDER_EXTERNAL_ENTITY_ID and from these values create a unique ORDER_ID (ORD_ID). This entity type is used to capture the external order number from feeder system and cross check with the internal order number. Also capture information about where the ORDER originated from. This table takes an ORGANIZATION, their identifier and map into a unique CDR generated FK.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_order_map';

