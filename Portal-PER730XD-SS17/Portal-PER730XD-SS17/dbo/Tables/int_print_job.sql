CREATE TABLE [dbo].[int_print_job] (
    [print_job_id]     UNIQUEIDENTIFIER NOT NULL,
    [page_number]      INT              NOT NULL,
    [patient_id]       UNIQUEIDENTIFIER NULL,
    [orig_patient_id]  UNIQUEIDENTIFIER NULL,
    [job_net_dt]       DATETIME         NOT NULL,
    [descr]            NVARCHAR (120)   NULL,
    [data_node]        INT              NOT NULL,
    [sweep_speed]      FLOAT (53)       NULL,
    [duration]         FLOAT (53)       NULL,
    [num_channels]     INT              NULL,
    [alarm_id]         UNIQUEIDENTIFIER NULL,
    [job_type]         VARCHAR (25)     NULL,
    [title]            VARCHAR (120)    NULL,
    [bed]              VARCHAR (25)     NULL,
    [recording_time]   VARCHAR (25)     NULL,
    [byte_height]      INT              NULL,
    [bitmap_height]    INT              NULL,
    [bitmap_width]     INT              NULL,
    [scale]            INT              NULL,
    [annotation1]      VARCHAR (120)    NULL,
    [annotation2]      VARCHAR (120)    NULL,
    [annotation3]      VARCHAR (120)    NULL,
    [annotation4]      VARCHAR (120)    NULL,
    [print_bitmap]     IMAGE            NULL,
    [twelve_lead_data] IMAGE            NULL,
    [end_of_job_sw]    TINYINT          NULL,
    [print_sw]         TINYINT          NULL,
    [printer_name]     VARCHAR (255)    NULL,
    [last_printed_dt]  DATETIME         NULL,
    [status_code]      CHAR (1)         NULL,
    [status_msg]       VARCHAR (500)    NULL,
    [start_rec]        IMAGE            NULL,
    [row_dt]           SMALLDATETIME    CONSTRAINT [DF_int_print_job_row_dt] DEFAULT (getdate()) NOT NULL,
    [row_id]           UNIQUEIDENTIFIER CONSTRAINT [DF_int_print_job_row_id] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_int_print_job_row_dt_row_id] PRIMARY KEY CLUSTERED ([row_dt] ASC, [row_id] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_int_print_job_print_sw_print_job_id_page_number_job_net_dt_end_of_job_sw]
    ON [dbo].[int_print_job]([print_sw] ASC)
    INCLUDE([print_job_id], [page_number], [job_net_dt], [end_of_job_sw]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the printing job information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_print_job';

