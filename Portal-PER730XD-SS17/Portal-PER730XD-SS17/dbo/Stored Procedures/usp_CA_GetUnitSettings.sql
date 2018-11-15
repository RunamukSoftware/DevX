CREATE PROCEDURE [dbo].[usp_CA_GetUnitSettings]
    (
     @unit_id AS UNIQUEIDENTIFIER  
    )
AS
BEGIN
    IF NOT EXISTS ( SELECT
                        [type_cd] AS [CFGTYPE],
                        [cfg_name] AS [CFGNAME],
                        [cfg_value] AS [CFGVALUE],
                        [cfg_xml_value] AS [CFGXMLVALUE],
                        [value_type] AS [VALUETYPE]
                    FROM
                        [dbo].[cfgValuesUnit]
                    WHERE
                        [unit_id] = @unit_id )
    BEGIN
        DECLARE @TEMP TABLE
            (
             [table_name] VARCHAR(25),
             [type_cd] VARCHAR(25),
             [cfg_name] VARCHAR(40),
             [cfg_value] DCFG_VALUES,
             [cfg_xml_value] XML,
             [value_type] VARCHAR(20)
            );

        DECLARE
            @GLOBAL_TABLE VARCHAR(25) = 'cfgValuesGlobal',
            @FACTORY_TABLE VARCHAR(25) = 'cfgValuesFactory';

        INSERT  INTO @TEMP
        SELECT
            @GLOBAL_TABLE,
            [type_cd],
            [cfg_name],
            [cfg_value],
            [cfg_xml_value],
            [value_type]
        FROM
            [dbo].[cfgValuesGlobal]
        WHERE
            [global_type] = 'false';

        INSERT  INTO @TEMP
        SELECT
            @FACTORY_TABLE,
            [type_cd],
            [cfg_name],
            [cfg_value],
            [cfg_xml_value],
            [value_type]
        FROM
            [dbo].[cfgValuesFactory]
        WHERE
            [global_type] = 'false';

        DECLARE @CURRENT VARCHAR(25);

        SET @CURRENT = @GLOBAL_TABLE;

        IF NOT EXISTS ( SELECT
                            [type_cd],
                            [cfg_name],
                            [cfg_value],
                            [cfg_xml_value],
                            [value_type]
                        FROM
                            @TEMP
                        WHERE
                            [table_name] = @GLOBAL_TABLE )
        BEGIN
            SET @CURRENT = @FACTORY_TABLE;
        END;

        IF NOT EXISTS ( SELECT
                            [type_cd] AS [CFGTYPE],
                            [cfg_name] AS [CFGNAME],
                            [cfg_value] AS [CFGVALUE],
                            [cfg_xml_value] AS [CFGXMLVALUE],
                            [value_type] AS [VALUETYPE]
                        FROM
                            [dbo].[cfgValuesUnit]
                        WHERE
                            [unit_id] = @unit_id )
        BEGIN
            INSERT  INTO [dbo].[cfgValuesUnit]
            SELECT
                @unit_id,
                [type_cd],
                [cfg_name],
                [cfg_value],
                [cfg_xml_value],
                [value_type]
            FROM
                @TEMP
            WHERE
                [table_name] = @CURRENT;
        END;
    END;

    SELECT
        [type_cd] AS [CFGTYPE],
        [cfg_name] AS [CFGNAME],
        [cfg_value] AS [CFGVALUE],
        [cfg_xml_value] AS [CFGXMLVALUE],
        [value_type] AS [VALUETYPE],
        CAST(0 AS BIT) AS [GLOBALTYPE]
    FROM
        [dbo].[cfgValuesUnit]
    WHERE
        [unit_id] = @unit_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the unit settings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetUnitSettings';

