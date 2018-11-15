CREATE PROCEDURE [old].[uspGetDefaultSettingNameList] (@TypeCode VARCHAR(25))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [cvf].[ConfigurationName] AS [CFGNAME]
        FROM
            [Configuration].[ValueFactory] AS [cvf]
        WHERE
            [cvf].[TypeCode] = @TypeCode;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetDefaultSettingNameList';

