CREATE TABLE [dbo].[int_reference_range] (
    [reference_range_id] INT           NOT NULL,
    [reference_range]    NVARCHAR (60) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_reference_range_reference_range_id]
    ON [dbo].[int_reference_range]([reference_range_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains the results value ranges that are associated with a specific RESULT.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_reference_range';

