CREATE TABLE [Intesys].[OutboundQueue] (
    [OutboundQueueID]          INT           IDENTITY (1, 1) NOT NULL,
    [OutboundID]               INT           NOT NULL,
    [MessageEvent]             NVARCHAR (3)  NOT NULL,
    [QueuedDateTime]           DATETIME2 (7) NOT NULL,
    [MessageStatus]            CHAR (1)      NOT NULL,
    [ProcessedDateTime]        DATETIME2 (7) NULL,
    [PatientID]                INT           NOT NULL,
    [OrderID]                  INT           NULL,
    [ObservationStartDateTime] DATETIME2 (7) NULL,
    [ObservationEndDateTime]   DATETIME2 (7) NULL,
    [CreatedDateTime]          DATETIME2 (7) CONSTRAINT [DF_OutboundQueue_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OutboundQueue_OutboundQueueID] PRIMARY KEY CLUSTERED ([OutboundQueueID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_OutboundQueue_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OutboundQueue_OutboundID]
    ON [Intesys].[OutboundQueue]([OutboundID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The int_outbound_queue table is used to start the outbound messaging process. A row is inserted into the int_outbound_queue telling the backend processes that an HL7 message needs to be generated for the corresponding PatientID and OrderID. A MessageStatus of N means the request has not been processed. A MessageStatus of R means the request has been processed. A MessageStatus of E means the request errored when trying to process. Generally only not processed (N) or Errored (E) records are kept in this table. Processed records imply a HL/7 message was successfully placed into the HL7_out_queue.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'OutboundQueue';

