CREATE TABLE [Archive].[Flowsheet] (
    [FlowsheetID]     INT           IDENTITY (1, 1) NOT NULL,
    [FlowsheetType]   NVARCHAR (50) NOT NULL,
    [OwnerID]         INT           NULL,
    [Name]            NVARCHAR (50) NULL,
    [Description]     NVARCHAR (50) NULL,
    [DisplayInMenu]   TINYINT       CONSTRAINT [DF_Flowsheet_DisplayInMenu] DEFAULT ((1)) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Flowsheet_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Flowsheet_FlowsheetID] PRIMARY KEY CLUSTERED ([FlowsheetID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all "flowsheets" defined by the site. A flowsheet is a high-level grouping of tests, results, values. Usually each department has unique flowsheets and sometimes types of doctors may have their own (i.e. Cardiologists). It is very similar to to concept of Test Groups but is geared towards data entry as opposed to display.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'Flowsheet';

