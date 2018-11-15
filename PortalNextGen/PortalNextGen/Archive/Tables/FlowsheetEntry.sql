CREATE TABLE [Archive].[FlowsheetEntry] (
    [FlowsheetEntryID]    INT           IDENTITY (1, 1) NOT NULL,
    [TestCodeID]          INT           NULL,
    [DataType]            NVARCHAR (50) NULL,
    [SelectListID]        INT           NULL,
    [Units]               NVARCHAR (50) NULL,
    [NormalFloat]         FLOAT (53)    NULL,
    [AbsoluteFloatHigh]   FLOAT (53)    NULL,
    [AbsoluteFloatLow]    FLOAT (53)    NULL,
    [WarningFloatHigh]    FLOAT (53)    NULL,
    [WarningFloatLow]     FLOAT (53)    NULL,
    [CriticalFloatHigh]   FLOAT (53)    NULL,
    [CriticalFloatLow]    FLOAT (53)    NULL,
    [NormalInteger]       INT           NULL,
    [AbsoluteIntegerHigh] INT           NULL,
    [AbsoluteIntegerLow]  INT           NULL,
    [WarningIntegerHigh]  INT           NULL,
    [WarningIntegerLow]   INT           NULL,
    [CriticalIntegerHigh] INT           NULL,
    [CriticalIntegerLow]  INT           NULL,
    [NormalString]        NVARCHAR (50) NULL,
    [MaximumLength]       INT           NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_FlowsheetEntry_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_FlowsheetEntry_FlowsheetEntryID] PRIMARY KEY CLUSTERED ([FlowsheetEntryID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FlowsheetEntry_FlowsheetEntryID]
    ON [Archive].[FlowsheetEntry]([FlowsheetEntryID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to control validation of each field (for data entry). It is used in conjunction with the int_flowsheet_detail table to drive the display/input logic.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'FlowsheetEntry';

