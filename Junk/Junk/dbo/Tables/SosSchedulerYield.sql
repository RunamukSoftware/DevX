CREATE TABLE [dbo].[SosSchedulerYield] (
	[SosSchedulerYieldID] INT NOT NULL IDENTITY(1, 1),
    [session_id]         SMALLINT       NOT NULL,
    [program_name]       NVARCHAR (128) NULL,
    [text]               NVARCHAR (MAX) NULL,
    [database_id]        SMALLINT       NOT NULL,
    [query_plan]         XML            NULL,
    [cpu_time]           INT            NOT NULL,
    [start_time]         DATETIME       NOT NULL,
    [total_elapsed_time] INT            CONSTRAINT [DF_SosSchedulerYield_total_elapsed_time] DEFAULT ((-1)) NOT NULL,
    [row_count]          BIGINT         CONSTRAINT [DF_SosSchedulerYield_row_count] DEFAULT ((-1)) NOT NULL, 
    CONSTRAINT [PK_SosSchedulerYield_SosSchedulerYieldID] PRIMARY KEY CLUSTERED ([SosSchedulerYieldID])
);
