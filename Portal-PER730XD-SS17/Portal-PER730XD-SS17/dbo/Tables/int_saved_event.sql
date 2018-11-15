CREATE TABLE [dbo].[int_saved_event] (
    [patient_id]               UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]          UNIQUEIDENTIFIER NULL,
    [event_id]                 INT              NOT NULL,
    [insert_dt]                DATETIME         NOT NULL,
    [user_id]                  UNIQUEIDENTIFIER NOT NULL,
    [orig_event_category]      INT              NOT NULL,
    [orig_event_type]          INT              NOT NULL,
    [start_dt]                 DATETIME         NOT NULL,
    [start_ft]                 BIGINT           NOT NULL,
    [center_ft]                BIGINT           NULL,
    [duration]                 INT              NOT NULL,
    [value1]                   INT              NOT NULL,
    [divisor1]                 INT              NOT NULL,
    [value2]                   INT              NULL,
    [divisor2]                 INT              NULL,
    [print_format]             INT              NOT NULL,
    [title]                    NVARCHAR (50)    NULL,
    [type]                     NVARCHAR (50)    NULL,
    [rate_calipers]            TINYINT          NOT NULL,
    [measure_calipers]         TINYINT          NOT NULL,
    [caliper_start_ft]         BIGINT           NULL,
    [caliper_end_ft]           BIGINT           NULL,
    [caliper_top]              INT              NULL,
    [caliper_bottom]           INT              NULL,
    [caliper_top_wave_type]    INT              NULL,
    [caliper_bottom_wave_type] INT              NULL,
    [annotate_data]            TINYINT          NOT NULL,
    [num_waveforms]            INT              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_saved_event_patient_id_event_id_insert_dt_user_id]
    ON [dbo].[int_saved_event]([patient_id] ASC, [event_id] ASC, [insert_dt] ASC, [user_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores events manually saved by the user. Each record is uniquely identified by patient_id, event_id and insert_dt. The data in this table is populated by the Patsrvr process. New records are added and no records are deleted.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_saved_event';

