CREATE TABLE [dbo].[int_flowsheet] (
    [flowsheet_id]    UNIQUEIDENTIFIER NULL,
    [flowsheet_type]  NVARCHAR (50)    NOT NULL,
    [owner_id]        UNIQUEIDENTIFIER NULL,
    [name]            NVARCHAR (50)    NULL,
    [description]     NVARCHAR (50)    NULL,
    [seq]             INT              NULL,
    [display_in_menu] TINYINT          CONSTRAINT [DF_int_flowsheet_display_in_menu] DEFAULT ((1)) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all "flowsheets" defined by the site. A flowsheet is a high-level grouping of tests, results, values. Usually each department has unique flowsheets and sometimes types of doctors may have their own (i.e. Cardiologists). It is very similar to to concept of Test Groups but is geared towards data entry as opposed to display.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_flowsheet';

