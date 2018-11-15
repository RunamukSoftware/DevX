CREATE TABLE [Archive].[FlowsheetDetail] (
    [FlowsheetDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [FlowsheetID]       INT           NOT NULL,
    [Name]              NVARCHAR (80) NOT NULL,
    [DetailType]        NVARCHAR (50) NOT NULL,
    [ParentID]          INT           NOT NULL,
    [Sequence]          INT           NOT NULL,
    [TestCodeID]        INT           NOT NULL,
    [ShowOnlyWhenData]  TINYINT       NOT NULL,
    [IsCompressed]      TINYINT       NOT NULL,
    [IsVisible]         TINYINT       NOT NULL,
    [FlowsheetEntryID]  INT           NOT NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_FlowsheetDetail_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_FlowsheetDetail_FlowsheetDetailID] PRIMARY KEY CLUSTERED ([FlowsheetDetailID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FlowsheetDetail_FlowsheetID_TestCodeID_FlowsheetDetailID]
    ON [Archive].[FlowsheetDetail]([FlowsheetID] ASC, [TestCodeID] ASC, [FlowsheetDetailID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines what tests and results should show on a given flowsheet. It is the detail table for the int_flowsheet table.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'FlowsheetDetail';

