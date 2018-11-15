CREATE TABLE [Intesys].[OrderLine] (
    [OrderLineID]            INT            IDENTITY (1, 1) NOT NULL,
    [OrderID]                INT            NOT NULL,
    [SequenceNumber]         SMALLINT       NOT NULL,
    [PatientID]              INT            NOT NULL,
    [OriginalPatientID]      INT            NULL,
    [StatusCodeID]           INT            NULL,
    [prov_svcCodeID]         INT            NULL,
    [UniversalServiceCodeID] INT            NULL,
    [TransportCodeID]        INT            NULL,
    [OrderLineComment]       NVARCHAR (MAX) NULL,
    [clin_info_comment]      NVARCHAR (MAX) NULL,
    [ReasonComment]          NVARCHAR (MAX) NULL,
    [scheduledDateTime]      DATETIME2 (7)  NULL,
    [observDateTime]         DATETIME2 (7)  NULL,
    [status_chgDateTime]     DATETIME2 (7)  NULL,
    [CreatedDateTime]        DATETIME2 (7)  CONSTRAINT [DF_OrderLine_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrderLine_OrderLineID] PRIMARY KEY CLUSTERED ([OrderLineID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_OrderLine_Order_OrderID] FOREIGN KEY ([OrderID]) REFERENCES [Intesys].[Order] ([OrderID]),
    CONSTRAINT [FK_OrderLine_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrderLine_OrderID_UniversalServiceCodeID_PatientID_SequenceNumber]
    ON [Intesys].[OrderLine]([OrderID] ASC, [UniversalServiceCodeID] ASC, [PatientID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The request for a specific service. One detailed entry of an ORDER requesting an instance of a service. The ORDER_LINE entity Type is used to hold individual orderable items within an ORDER. It is the detail of an order. Deleted Columns: priority_codeID, ord_cntl_codeID', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'OrderLine';

