CREATE PROCEDURE [dbo].[usp_CA_GetPatientSettings]
    (
     @patient_id AS UNIQUEIDENTIFIER,
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
                        [dbo].[cfgValuesPatient]
                    WHERE
                        [patient_id] = @patient_id )
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

        DECLARE --@PAT_TABLE VARCHAR(25) = 'cfgValuesPatient',
            @UNIT_TABLE VARCHAR(25) = 'cfgValuesUnit',
            @FACTORY_TABLE VARCHAR(25) = 'cfgValuesFactory',
            @GLOBAL_TABLE VARCHAR(25) = 'cfgValuesGlobal',
            @CURRENT VARCHAR(25);

        INSERT  INTO @TEMP
        SELECT
            @UNIT_TABLE,
            [type_cd],
            [cfg_name],
            [cfg_value],
            [cfg_xml_value],
            [value_type]
        FROM
            [dbo].[cfgValuesUnit]
        WHERE
            [unit_id] = @unit_id; 

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

        SET @CURRENT = @UNIT_TABLE;

        IF NOT EXISTS ( SELECT
                            [type_cd],
                            [cfg_name],
                            [cfg_value],
                            [cfg_xml_value],
                            [value_type]
                        FROM
                            @TEMP
                        WHERE
                            [table_name] = @UNIT_TABLE )
        BEGIN
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
                SET @CURRENT = @FACTORY_TABLE;
        END;

        IF NOT EXISTS ( SELECT
                            [type_cd] AS [CFGTYPE],
                            [cfg_name] AS [CFGNAME],
                            [cfg_value] AS [CFGVALUE],
                            [cfg_xml_value] AS [CFGXMLVALUE],
                            [value_type] AS [VALUETYPE]
                        FROM
                            [dbo].[cfgValuesPatient]
                        WHERE
                            [patient_id] = @patient_id )
        BEGIN
            INSERT  INTO [dbo].[cfgValuesPatient]
            SELECT
                @patient_id,
                [type_cd],
                [cfg_name],
                [cfg_value],
                [cfg_xml_value],
                [value_type],
                GETDATE( )
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
        [dbo].[cfgValuesPatient]
    WHERE
        [patient_id] = @patient_id; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the patient settings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetPatientSettings';

