CREATE PROCEDURE [dbo].[p_Set_cfg_Values]
    (
     @keyname VARCHAR(40),
     @keyvalue VARCHAR(100)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_cfg_values]
    SET
        [keyvalue] = @keyvalue
    WHERE
        [keyname] = @keyname;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Set_cfg_Values';

