CREATE PROCEDURE [dbo].[usp_CA_SaveConfigurationSetting]
    (
     @setting_type INT,
     @patient_id UNIQUEIDENTIFIER,
     @unit_id UNIQUEIDENTIFIER,
     @type_cd VARCHAR(25),
     @cfg_name VARCHAR(40),
     @cfg_value DCFG_VALUES,
     @cfg_xml_value XML,
     @global_type BIT,
     @value_type VARCHAR(40) -- TG - should be VARCHAR(20)
    )
AS
BEGIN
    IF (@setting_type = 2) --Global
    BEGIN
        IF EXISTS ( SELECT
                        1
                    FROM
                        [dbo].[cfgValuesGlobal]
                    WHERE
                        [type_cd] = @type_cd
                        AND [cfg_name] = @cfg_name )
        BEGIN
            UPDATE
                [dbo].[cfgValuesGlobal]
            SET
                [cfg_value] = @cfg_value,
                [cfg_xml_value] = @cfg_xml_value
            WHERE
                [type_cd] = @type_cd
                AND [cfg_name] = @cfg_name;      
        END;
        ELSE
        BEGIN
            INSERT  INTO [dbo].[cfgValuesGlobal]
                    ([type_cd],
                     [cfg_name],
                     [cfg_value],
                     [cfg_xml_value],
                     [global_type],
                     [value_type]
                    )
            VALUES
                    (@type_cd,
                     @cfg_name,
                     @cfg_value,
                     @cfg_xml_value,
                     @global_type,
                     CAST(@value_type AS VARCHAR(20))
                    );
        END;
    END;

    IF (@setting_type = 3) --Patient
    BEGIN
        IF EXISTS ( SELECT
                        1
                    FROM
                        [dbo].[cfgValuesPatient]
                    WHERE
                        [patient_id] = @patient_id
                        AND [type_cd] = @type_cd
                        AND [cfg_name] = @cfg_name )
        BEGIN
            UPDATE
                [dbo].[cfgValuesPatient]
            SET
                [cfg_value] = @cfg_value,
                [cfg_xml_value] = @cfg_xml_value
            WHERE
                [patient_id] = @patient_id
                AND [type_cd] = @type_cd
                AND [cfg_name] = @cfg_name;      
        END;
        ELSE
        BEGIN
            INSERT  INTO [dbo].[cfgValuesPatient]
                    ([patient_id],
                     [type_cd],
                     [cfg_name],
                     [cfg_value],
                     [cfg_xml_value],
                     [value_type]
                    )
            VALUES
                    (@patient_id,
                     @type_cd,
                     @cfg_name,
                     @cfg_value,
                     @cfg_xml_value,
                     CAST(@value_type AS VARCHAR(20))
                    );
        END;
  
    END;

    IF (@setting_type = 4) --Unit
    BEGIN
        IF EXISTS ( SELECT
                        1
                    FROM
                        [dbo].[cfgValuesUnit]
                    WHERE
                        [unit_id] = @unit_id
                        AND [type_cd] = @type_cd
                        AND [cfg_name] = @cfg_name )
        BEGIN
            UPDATE
                [dbo].[cfgValuesUnit]
            SET
                [cfg_value] = @cfg_value,
                [cfg_xml_value] = @cfg_xml_value
            WHERE
                [unit_id] = @unit_id
                AND [type_cd] = @type_cd
                AND [cfg_name] = @cfg_name;      
        END;
        ELSE
        BEGIN
            INSERT  INTO [dbo].[cfgValuesUnit]
                    ([unit_id],
                     [type_cd],
                     [cfg_name],
                     [cfg_value],
                     [cfg_xml_value],
                     [value_type]
                    )
            VALUES
                    (@unit_id,
                     @type_cd,
                     @cfg_name,
                     @cfg_value,
                     @cfg_xml_value,
                     CAST(@value_type AS VARCHAR(20))
                    );
        END;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Saves the configuration setting.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_SaveConfigurationSetting';

