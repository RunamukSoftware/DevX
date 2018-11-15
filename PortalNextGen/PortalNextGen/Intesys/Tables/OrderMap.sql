CREATE TABLE [Intesys].[OrderMap] (
    [OrderMapID]        INT              IDENTITY (1, 1) NOT NULL,
    [OrderID]           INT              NOT NULL,
    [PatientID]         INT              NOT NULL,
    [OriginalPatientID] INT              NULL,
    [OrganizationID]    INT              NOT NULL,
    [SystemID]          INT              NOT NULL,
    [OrderXID]          UNIQUEIDENTIFIER NOT NULL,
    [TypeCode]          CHAR (1)         NULL,
    [SequenceNumber]    INT              NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)    CONSTRAINT [DF_OrderMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrderMap_OrderMapID] PRIMARY KEY CLUSTERED ([OrderMapID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_OrderMap_Order_OrderID] FOREIGN KEY ([OrderID]) REFERENCES [Intesys].[Order] ([OrderID]),
    CONSTRAINT [FK_OrderMap_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID]),
    CONSTRAINT [FK_OrderMap_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderMap_OrderID]
    ON [Intesys].[OrderMap]([OrderID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrderMap_PatientID_OrganizationID_SystemID_OrderXID_TypeCode_SequenceNumber]
    ON [Intesys].[OrderMap]([PatientID] ASC, [OrganizationID] ASC, [SystemID] ASC, [OrderXID] ASC, [TypeCode] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table''s purpose is to take the ORGANZATION_ENTITYID, SYSTEM_ENTITYID, and ORDER_EXTERNAL_ENTITYID and from these values create a unique OrderID (ORDID). This entity Type is used to capture the external order number from feeder system and cross check with the internal order number. Also capture information about where the ORDER originated from. This table takes an ORGANIZATION, their identifier and map into a unique CDR generated FK.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'OrderMap';

