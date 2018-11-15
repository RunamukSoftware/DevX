CREATE PROCEDURE [dbo].[p_Get_cfg_Values] (@keyname VARCHAR(40))
AS
BEGIN
    SELECT
        [keyvalue]
    FROM
        [dbo].[int_cfg_values]
    WHERE
        [keyname] = @keyname;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Get_cfg_Values';

