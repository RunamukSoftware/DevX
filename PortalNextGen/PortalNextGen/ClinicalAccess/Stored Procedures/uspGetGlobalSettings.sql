CREATE PROCEDURE [ClinicalAccess].[uspGetGlobalSettings]
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [cvg].[TypeCode]              AS [CFGTYPE],
                    [cvg].[ConfigurationName]     AS [CFGNAME],
                    [cvg].[ConfigurationValue]    AS [CFGVALUE],
                    [cvg].[ConfigurationXmlValue] AS [CFGXMLVALUE],
                    [cvg].[ValueType]             AS [VALUETYPE],
                    [cvg].[GlobalType]            AS [GLOBALTYPE]
                FROM
                    [Configuration].[ValueGlobal] AS [cvg]
            )
            BEGIN
                INSERT INTO [Configuration].[ValueGlobal]
                    (
                        [TypeCode],
                        [ConfigurationName],
                        [ConfigurationValue],
                        [ConfigurationXmlValue],
                        [ValueType],
                        [GlobalType]
                    )
                            SELECT
                                [cvf].[TypeCode],
                                [cvf].[ConfigurationName],
                                [cvf].[ConfigurationValue],
                                [cvf].[ConfigurationXmlValue],
                                [cvf].[ValueType],
                                [cvf].[GlobalType]
                            FROM
                                [Configuration].[ValueFactory] AS [cvf];
            END;

        SELECT
            [cvg].[TypeCode]              AS [CFGTYPE],
            [cvg].[ConfigurationName]     AS [CFGNAME],
            [cvg].[ConfigurationValue]    AS [CFGVALUE],
            [cvg].[ConfigurationXmlValue] AS [CFGXMLVALUE],
            [cvg].[ValueType]             AS [VALUETYPE],
            [cvg].[GlobalType]            AS [GLOBALTYPE]
        FROM
            [Configuration].[ValueGlobal] AS [cvg];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the global settings', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetGlobalSettings';

