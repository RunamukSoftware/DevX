CREATE PROCEDURE [dbo].[p_ugTest]
    (
     @table VARCHAR(80),
     @col VARCHAR(80)
    )
AS
BEGIN
    DECLARE @sqlstr VARCHAR(255);

    SET @sqlstr = 'SELECT ' + @col + ' FROM ' + @table;

    EXEC (@sqlstr);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_ugTest';

