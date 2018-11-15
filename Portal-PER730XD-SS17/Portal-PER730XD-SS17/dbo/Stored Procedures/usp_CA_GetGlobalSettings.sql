CREATE PROCEDURE [dbo].[usp_CA_GetGlobalSettings]
AS
BEGIN
    IF NOT EXISTS ( SELECT
                        [type_cd] AS [CFGTYPE],
                        [cfg_name] AS [CFGNAME],
                        [cfg_value] AS [CFGVALUE],
                        [cfg_xml_value] AS [CFGXMLVALUE],
                        [value_type] AS [VALUETYPE],
                        [global_type] AS [GLOBALTYPE]
                    FROM
                        [dbo].[cfgValuesGlobal] )
    BEGIN
        INSERT  INTO [dbo].[cfgValuesGlobal]
        SELECT
            [type_cd],
            [cfg_name],
            [cfg_value],
            [cfg_xml_value],
            [value_type],
            [global_type]
        FROM
            [dbo].[cfgValuesFactory];          
    END;

    SELECT
        [type_cd] AS [CFGTYPE],
        [cfg_name] AS [CFGNAME],
        [cfg_value] AS [CFGVALUE],
        [cfg_xml_value] AS [CFGXMLVALUE],
        [value_type] AS [VALUETYPE],
        [global_type] AS [GLOBALTYPE]
    FROM
        [dbo].[cfgValuesGlobal];    
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the global settings', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetGlobalSettings';

