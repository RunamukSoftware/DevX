CREATE PROCEDURE [dbo].[UpdateXmlValue]
    (
     @type_cd VARCHAR(25),
     @cfg_name VARCHAR(40),
     @isGlobal VARCHAR(10),
     @Filename VARCHAR(100)
    )
AS
BEGIN
    IF EXISTS ( SELECT
                    *
                FROM
                    [dbo].[cfgValuesFactory]
                WHERE
                    [type_cd] = @type_cd
                    AND [cfg_name] = @cfg_name )
        DELETE
            [dbo].[cfgValuesFactory]
        WHERE
            [type_cd] = @type_cd
            AND [cfg_name] = @cfg_name;

    IF EXISTS ( SELECT
                    *
                FROM
                    [dbo].[cfgValuesGlobal]
                WHERE
                    [type_cd] = @type_cd
                    AND [cfg_name] = @cfg_name )
        DELETE
            [dbo].[cfgValuesGlobal]
        WHERE
            [type_cd] = @type_cd
            AND [cfg_name] = @cfg_name;

    IF EXISTS ( SELECT
                    *
                FROM
                    [dbo].[cfgValuesUnit]
                WHERE
                    [type_cd] = @type_cd
                    AND [cfg_name] = @cfg_name )
        DELETE
            [dbo].[cfgValuesUnit]
        WHERE
            [type_cd] = @type_cd
            AND [cfg_name] = @cfg_name;

    IF EXISTS ( SELECT
                    *
                FROM
                    [dbo].[cfgValuesPatient]
                WHERE
                    [type_cd] = @type_cd
                    AND [cfg_name] = @cfg_name )
        DELETE
            [dbo].[cfgValuesPatient]
        WHERE
            [type_cd] = @type_cd
            AND [cfg_name] = @cfg_name;

    DECLARE @SQL VARCHAR(2000);

    SET @SQL = '
    INSERT INTO [dbo].[cfgValuesFactory]
        (type_cd
        ,cfg_name
        ,cfg_value
        ,value_type
        ,global_type
        ,cfg_xml_value          
        )
    SELECT ''' + @type_cd + ''' AS [type_cd], ''' + @cfg_name + ''' AS [cfg_name],
    NULL AS [cfg_value],
    ''xml'' AS [value_type], ''' + @isGlobal + ''' AS [global_type],
    BulkColumn FROM OPENROWSET(bulk ''' + @Filename + ''', SINGLE_BLOB) AS [cfg_xml_value]';

    EXEC (@SQL);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'UpdateXmlValue';

