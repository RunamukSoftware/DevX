CREATE PROCEDURE [dbo].[GetIntCfgValues] (@keyname [DKEY_NAME])
AS
BEGIN
    SELECT
        [keyvalue] AS [KEY_VALUE]
    FROM
        [dbo].[int_cfg_values]
    WHERE
        [keyname] = @keyname;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetIntCfgValues';

