CREATE TABLE [dbo].[int_print_job_waveform] (
    [print_job_id]            UNIQUEIDENTIFIER NOT NULL,
    [page_number]             INT              NOT NULL,
    [seq_no]                  INT              NOT NULL,
    [waveform_type]           VARCHAR (25)     NOT NULL,
    [duration]                FLOAT (53)       NULL,
    [channel_type]            VARCHAR (50)     NULL,
    [module_num]              INT              NULL,
    [channel_num]             INT              NULL,
    [sweep_speed]             FLOAT (53)       NULL,
    [label_min]               FLOAT (53)       NULL,
    [label_max]               FLOAT (53)       NULL,
    [show_units]              TINYINT          NULL,
    [annotation_channel_type] INT              NULL,
    [offset]                  INT              NULL,
    [scale]                   INT              NULL,
    [primary_annotation]      VARCHAR (50)     NULL,
    [secondary_annotation]    VARCHAR (50)     NULL,
    [waveform_data]           TEXT             NULL,
    [grid_type]               INT              NULL,
    [scale_labels]            VARCHAR (120)    NULL,
    [row_dt]                  SMALLDATETIME    CONSTRAINT [DF_int_print_job_waveform_row_dt] DEFAULT (getdate()) NOT NULL,
    [row_id]                  UNIQUEIDENTIFIER CONSTRAINT [DF_int_print_job_waveform_row_id] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_int_print_job_waveform_row_dt_row_id] PRIMARY KEY CLUSTERED ([row_dt] ASC, [row_id] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_print_job_waveform_print_job_id_page_number_seq_no_module_num_channel_num]
    ON [dbo].[int_print_job_waveform]([print_job_id] ASC, [page_number] ASC, [seq_no] ASC, [module_num] ASC, [channel_num] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the waveform printing job information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_print_job_waveform';

