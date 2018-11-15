CREATE TABLE [dbo].[int_patient_image] (
    [patient_id]      UNIQUEIDENTIFIER NULL,
    [order_id]        UNIQUEIDENTIFIER NULL,
    [seq_no]          SMALLINT         NOT NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [image_type_cid]  INT              NULL,
    [image_path]      NVARCHAR (255)   NULL,
    [image]           IMAGE            NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_patient_image_patient_id_order_id_seq_no]
    ON [dbo].[int_patient_image]([patient_id] ASC, [order_id] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links Dome medical images to each patient. OrderId links the image to a specific order so that when viewing a report detail screen, we can display an image button if an image is present. The image button then displays all images for the current order.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient_image';

