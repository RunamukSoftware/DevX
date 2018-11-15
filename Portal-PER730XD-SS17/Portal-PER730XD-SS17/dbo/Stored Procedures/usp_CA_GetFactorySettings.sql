CREATE PROCEDURE [dbo].[usp_CA_GetFactorySettings]
AS
BEGIN
    SELECT
        [type_cd] AS [CFGTYPE],
        [cfg_name] AS [CFGNAME],
        [cfg_value] AS [CFGVALUE],
        [cfg_xml_value] AS [CFGXMLVALUE],
        [value_type] AS [VALUETYPE],
        [global_type] AS [GLOBALTYPE]
    FROM
        [dbo].[cfgValuesFactory];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetFactorySettings';

