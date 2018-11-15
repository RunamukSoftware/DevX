CREATE PROCEDURE [dbo].[GetDefaultSettingNameList] (@type_cd VARCHAR(25))
AS
BEGIN
    SELECT
        [cfg_name] AS [CFGNAME]
    FROM
        [dbo].[cfgValuesFactory]
    WHERE
        [type_cd] = @type_cd;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetDefaultSettingNameList';

