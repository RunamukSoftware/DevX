CREATE PROCEDURE [ClinicalAccess].[uspSaveConfigurationSetting]
    (
        @SettingType           INT,
        @PatientID             INT,
        @UnitID                INT,
        @TypeCode              VARCHAR(25),
        @ConfigurationName     VARCHAR(40),
        @ConfigurationValue    NVARCHAR(1800),
        @ConfigurationXmlValue XML,
        @GlobalType            BIT,
        @ValueType             VARCHAR(20)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@SettingType = 2) --Global
            BEGIN
                IF EXISTS
                    (
                        SELECT
                            1
                        FROM
                            [Configuration].[ValueGlobal] AS [cvg]
                        WHERE
                            [cvg].[TypeCode] = @TypeCode
                            AND [cvg].[ConfigurationName] = @ConfigurationName
                    )
                    BEGIN
                        UPDATE
                            [Configuration].[ValueGlobal]
                        SET
                            [ConfigurationValue] = @ConfigurationValue,
                            [ConfigurationXmlValue] = @ConfigurationXmlValue
                        WHERE
                            [TypeCode] = @TypeCode
                            AND [ConfigurationName] = @ConfigurationName;
                    END;
                ELSE
                    BEGIN
                        INSERT INTO [Configuration].[ValueGlobal]
                            (
                                [TypeCode],
                                [ConfigurationName],
                                [ConfigurationValue],
                                [ConfigurationXmlValue],
                                [GlobalType],
                                [ValueType]
                            )
                        VALUES
                            (
                                @TypeCode,
                                @ConfigurationName,
                                @ConfigurationValue,
                                @ConfigurationXmlValue,
                                @GlobalType,
                                @ValueType
                            );
                    END;
            END;

        IF (@SettingType = 3) --Patient
            BEGIN
                IF EXISTS
                    (
                        SELECT
                            1
                        FROM
                            [Configuration].[ValuePatient] AS [cvp]
                        WHERE
                            [cvp].[PatientID] = @PatientID
                            AND [cvp].[TypeCode] = @TypeCode
                            AND [cvp].[ConfigurationName] = @ConfigurationName
                    )
                    BEGIN
                        UPDATE
                            [Configuration].[ValuePatient]
                        SET
                            [ConfigurationValue] = @ConfigurationValue,
                            [ConfigurationXmlValue] = @ConfigurationXmlValue
                        WHERE
                            [PatientID] = @PatientID
                            AND [TypeCode] = @TypeCode
                            AND [ConfigurationName] = @ConfigurationName;
                    END;
                ELSE
                    BEGIN
                        INSERT INTO [Configuration].[ValuePatient]
                            (
                                [PatientID],
                                [TypeCode],
                                [ConfigurationName],
                                [ConfigurationValue],
                                [ConfigurationXmlValue],
                                [ValueType]
                            )
                        VALUES
                            (
                                @PatientID,
                                @TypeCode,
                                @ConfigurationName,
                                @ConfigurationValue,
                                @ConfigurationXmlValue,
                                @ValueType
                            );
                    END;

            END;

        IF (@SettingType = 4) --Unit
            BEGIN
                IF EXISTS
                    (
                        SELECT
                            1
                        FROM
                            [Configuration].[ValueUnit] AS [cvu]
                        WHERE
                            [cvu].[UnitID] = @UnitID
                            AND [cvu].[TypeCode] = @TypeCode
                            AND [cvu].[ConfigurationName] = @ConfigurationName
                    )
                    BEGIN
                        UPDATE
                            [Configuration].[ValueUnit]
                        SET
                            [ConfigurationValue] = @ConfigurationValue,
                            [ConfigurationXmlValue] = @ConfigurationXmlValue
                        WHERE
                            [UnitID] = @UnitID
                            AND [TypeCode] = @TypeCode
                            AND [ConfigurationName] = @ConfigurationName;
                    END;
                ELSE
                    BEGIN
                        INSERT INTO [Configuration].[ValueUnit]
                            (
                                [UnitID],
                                [TypeCode],
                                [ConfigurationName],
                                [ConfigurationValue],
                                [ConfigurationXmlValue],
                                [ValueType]
                            )
                        VALUES
                            (
                                @UnitID,
                                @TypeCode,
                                @ConfigurationName,
                                @ConfigurationValue,
                                @ConfigurationXmlValue,
                                @ValueType
                            );
                    END;
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Saves the configuration setting.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspSaveConfigurationSetting';

