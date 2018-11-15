CREATE TABLE [dbo].[int_outbound_queue] (
    [outbound_id]  UNIQUEIDENTIFIER NOT NULL,
    [msg_event]    NVARCHAR (3)     NOT NULL,
    [queued_dt]    DATETIME         NOT NULL,
    [msg_status]   CHAR (1)         NOT NULL,
    [processed_dt] DATETIME         NULL,
    [patient_id]   UNIQUEIDENTIFIER NOT NULL,
    [order_id]     UNIQUEIDENTIFIER NULL,
    [obs_start_dt] DATETIME         NULL,
    [obs_end_dt]   DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_outbound_queue_outbound_id]
    ON [dbo].[int_outbound_queue]([outbound_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The int_outbound_queue table is used to start the outbound messaging process. A row is inserted into the int_outbound_queue telling the backend processes that an HL7 message needs to be generated for the corresponding patient_id and order_id. A msg_status of N means the request has not been processed. A msg_status of R means the request has been processed. A msg_status of E means the request errored when trying to process. Generally only not processed (N) or Errored (E) records are kept in this table. Processed records imply a HL/7 message was successfully placed into the HL7_out_queue.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_outbound_queue';

