CREATE PROCEDURE [ClinicalAccess].[uspGetUnitSettings] (@UnitID AS INT)
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [cvu].[TypeCode]              AS [CFGTYPE],
                    [cvu].[ConfigurationName]     AS [CFGNAME],
                    [cvu].[ConfigurationValue]    AS [CFGVALUE],
                    [cvu].[ConfigurationXmlValue] AS [CFGXMLVALUE],
                    [cvu].[ValueType]             AS [VALUETYPE]
                FROM
                    [Configuration].[ValueUnit] AS [cvu]
                WHERE
                    [cvu].[UnitID] = @UnitID
            )
            BEGIN
                DECLARE @TEMP TABLE
                    (
                        [TableName]             VARCHAR(25)    NOT NULL,
                        [TypeCode]              VARCHAR(25)    NOT NULL,
                        [ConfigurationName]     VARCHAR(40)    NOT NULL,
                        [ConfigurationValue]    NVARCHAR(1800) NOT NULL,
                        [ConfigurationXmlValue] XML            NOT NULL,
                        [ValueType]             VARCHAR(20)    NOT NULL
                    );

                DECLARE
                    @GLOBAL_TABLE  VARCHAR(25) = 'cfgValuesGlobal',
                    @FACTORY_TABLE VARCHAR(25) = 'cfgValuesFactory';

                INSERT INTO @TEMP
                    (
                        [TableName],
                        [TypeCode],
                        [ConfigurationName],
                        [ConfigurationValue],
                        [ConfigurationXmlValue],
                        [ValueType]
                    )
                            SELECT
                                @GLOBAL_TABLE,
                                [cvg].[TypeCode],
                                [cvg].[ConfigurationName],
                                [cvg].[ConfigurationValue],
                                [cvg].[ConfigurationXmlValue],
                                [cvg].[ValueType]
                            FROM
                                [Configuration].[ValueGlobal] AS [cvg]
                            WHERE
                                [cvg].[GlobalType] = 'false';

                INSERT INTO @TEMP
                    (
                        [TableName],
                        [TypeCode],
                        [ConfigurationName],
                        [ConfigurationValue],
                        [ConfigurationXmlValue],
                        [ValueType]
                    )
                            SELECT
                                @FACTORY_TABLE,
                                [cvf].[TypeCode],
                                [cvf].[ConfigurationName],
                                [cvf].[ConfigurationValue],
                                [cvf].[ConfigurationXmlValue],
                                [cvf].[ValueType]
                            FROM
                                [Configuration].[ValueFactory] AS [cvf]
                            WHERE
                                [cvf].[GlobalType] = 'false';

                DECLARE @CURRENT VARCHAR(25);

                SET @CURRENT = @GLOBAL_TABLE;

                IF NOT EXISTS
                    (
                        SELECT
                            [TypeCode],
                            [ConfigurationName],
                            [ConfigurationValue],
                            [ConfigurationXmlValue],
                            [ValueType]
                        FROM
                            @TEMP
                        WHERE
                            [TableName] = @GLOBAL_TABLE
                    )
                    BEGIN
                        SET @CURRENT = @FACTORY_TABLE;
                    END;

                IF NOT EXISTS
                    (
                        SELECT
                            [cvu].[TypeCode]              AS [CFGTYPE],
                            [cvu].[ConfigurationName]     AS [CFGNAME],
                            [cvu].[ConfigurationValue]    AS [CFGVALUE],
                            [cvu].[ConfigurationXmlValue] AS [CFGXMLVALUE],
                            [cvu].[ValueType]             AS [VALUETYPE]
                        FROM
                            [Configuration].[ValueUnit] AS [cvu]
                        WHERE
                            [cvu].[UnitID] = @UnitID
                    )
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
                                    SELECT
                                        @UnitID,
                                        [TypeCode],
                                        [ConfigurationName],
                                        [ConfigurationValue],
                                        [ConfigurationXmlValue],
                                        [ValueType]
                                    FROM
                                        @TEMP
                                    WHERE
                                        [TableName] = @CURRENT;
                    END;
            END;

        SELECT
            [cvu].[TypeCode]              AS [CFGTYPE],
            [cvu].[ConfigurationName]     AS [CFGNAME],
            [cvu].[ConfigurationValue]    AS [CFGVALUE],
            [cvu].[ConfigurationXmlValue] AS [CFGXMLVALUE],
            [cvu].[ValueType]             AS [VALUETYPE],
            CAST(0 AS BIT)                AS [GLOBALTYPE]
        FROM
            [Configuration].[ValueUnit] AS [cvu]
        WHERE
            [cvu].[UnitID] = @UnitID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the unit settings.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetUnitSettings';

