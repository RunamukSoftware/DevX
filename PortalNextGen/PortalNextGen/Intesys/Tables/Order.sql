CREATE TABLE [Intesys].[Order] (
    [OrderID]                INT           IDENTITY (1, 1) NOT NULL,
    [EncounterID]            INT           NOT NULL,
    [PatientID]              INT           NOT NULL,
    [OriginalPatientID]      INT           NOT NULL,
    [PriorityCodeID]         INT           NOT NULL,
    [StatusCodeID]           INT           NOT NULL,
    [UniversalServiceCodeID] INT           NOT NULL,
    [OrderPersonID]          INT           NOT NULL,
    [OrderDateTime]          DATETIME2 (7) NOT NULL,
    [EnterID]                INT           NOT NULL,
    [VerificationID]         INT           NOT NULL,
    [TranscriberID]          INT           NOT NULL,
    [ParentOrderID]          INT           NOT NULL,
    [ChildOrderSwitch]       BIT           NOT NULL,
    [OrderControlCodeID]     INT           NOT NULL,
    [HistorySwitch]          BIT           NOT NULL,
    [MonitorSwitch]          BIT           NOT NULL,
    [CreatedDateTime]        DATETIME2 (7) CONSTRAINT [DF_Order_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Order_OrderID] PRIMARY KEY CLUSTERED ([OrderID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Order_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Order_PatientID_OrderID_EncounterID]
    ON [Intesys].[Order]([PatientID] ASC, [OrderID] ASC, [EncounterID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Order_EncounterID]
    ON [Intesys].[Order]([EncounterID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all orders for every patient.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Order';

