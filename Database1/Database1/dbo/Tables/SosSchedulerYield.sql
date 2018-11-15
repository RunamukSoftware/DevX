CREATE TABLE [dbo].[SosSchedulerYield] (
    [session_id]         SMALLINT       NOT NULL,
    [program_name]       NVARCHAR (128) NULL,
    [text]               NVARCHAR (MAX) NULL,
    [database_id]        SMALLINT       NOT NULL,
    [query_plan]         XML            NULL,
    [cpu_time]           INT            NOT NULL,
    [start_time]         DATETIME       NOT NULL,
    [total_elapsed_time] INT            CONSTRAINT [DF_total_elapsed_time] DEFAULT ((0)) NOT NULL,
    [row_count]          BIGINT         CONSTRAINT [DF_row_count] DEFAULT ((0)) NOT NULL
);

