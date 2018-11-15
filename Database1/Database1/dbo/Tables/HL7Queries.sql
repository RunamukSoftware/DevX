CREATE TABLE [dbo].[HL7Queries] (
    [_name_]                    NVARCHAR (50)  NOT NULL,
    [_timestamp_]               NVARCHAR (50)  NOT NULL,
    [_timestamp__UTC__]         NVARCHAR (50)  NOT NULL,
    [_cpu_time_]                NVARCHAR (50)  NOT NULL,
    [_duration_]                NVARCHAR (50)  NOT NULL,
    [_physical_reads_]          NVARCHAR (50)  NOT NULL,
    [_logical_reads_]           NVARCHAR (50)  NOT NULL,
    [_writes_]                  NVARCHAR (50)  NOT NULL,
    [_result_]                  NVARCHAR (50)  NOT NULL,
    [_row_count_]               NVARCHAR (50)  NOT NULL,
    [_connection_reset_option_] NVARCHAR (50)  NOT NULL,
    [_object_name_]             NVARCHAR (50)  NOT NULL,
    [_statement_]               NVARCHAR (MAX) NOT NULL,
    [_data_stream_]             NVARCHAR (MAX) NOT NULL,
    [_output_parameters_]       NVARCHAR (50)  NOT NULL,
    [_database_name_]           NVARCHAR (50)  NOT NULL,
    [_database_id_]             NVARCHAR (50)  NOT NULL,
    [_client_hostname_]         NVARCHAR (50)  NOT NULL,
    [_client_app_name_]         NVARCHAR (50)  NOT NULL,
    [_sql_text_]                NVARCHAR (MAX) NOT NULL
);

