CREATE TABLE [dbo].[int_mon_request] (
    [req_id]     INT              IDENTITY (0, 1) NOT NULL,
    [monitor_id] UNIQUEIDENTIFIER NOT NULL,
    [req_type]   NVARCHAR (10)    NOT NULL,
    [req_args]   NVARCHAR (100)   NULL,
    [status]     NVARCHAR (2)     NULL,
    [mod_utc_dt] DATETIME         CONSTRAINT [DEF_int_mon_request_mod_utc_dt] DEFAULT (getutcdate()) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_mon_request_req_id]
    ON [dbo].[int_mon_request]([req_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the request for monitors'' information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_mon_request';

