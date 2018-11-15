CREATE PROCEDURE [ClinicalAccess].[uspGetFactorySettings]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [cvf].[TypeCode]              AS [CFGTYPE],
            [cvf].[ConfigurationName]     AS [CFGNAME],
            [cvf].[ConfigurationValue]    AS [CFGVALUE],
            [cvf].[ConfigurationXmlValue] AS [CFGXMLVALUE],
            [cvf].[ValueType]             AS [VALUETYPE],
            [cvf].[GlobalType]           AS [GLOBALTYPE]
        FROM
            [Configuration].[ValueFactory] AS [cvf];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetFactorySettings';

