CREATE PROCEDURE [old].[uspUpdateXmlValue]
    (
        @TypeCode          VARCHAR(25),
        @ConfigurationName VARCHAR(40),
        @IsGlobal          VARCHAR(10),
        @Filename          VARCHAR(100),
        @Debug             BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS
            (
                SELECT
                    *
                FROM
                    [Configuration].[ValueFactory] AS [cvf]
                WHERE
                    [cvf].[TypeCode] = @TypeCode
                    AND [cvf].[ConfigurationName] = @ConfigurationName
            )
            DELETE
            [Configuration].[ValueFactory]
            WHERE
                [TypeCode] = @TypeCode
                AND [ConfigurationName] = @ConfigurationName;

        IF EXISTS
            (
                SELECT
                    *
                FROM
                    [Configuration].[ValueGlobal] AS [cvg]
                WHERE
                    [cvg].[TypeCode] = @TypeCode
                    AND [cvg].[ConfigurationName] = @ConfigurationName
            )
            DELETE
            [Configuration].[ValueGlobal]
            WHERE
                [TypeCode] = @TypeCode
                AND [ConfigurationName] = @ConfigurationName;

        IF EXISTS
            (
                SELECT
                    *
                FROM
                    [Configuration].[ValueUnit] AS [cvu]
                WHERE
                    [cvu].[TypeCode] = @TypeCode
                    AND [cvu].[ConfigurationName] = @ConfigurationName
            )
            DELETE
            [Configuration].[ValueUnit]
            WHERE
                [TypeCode] = @TypeCode
                AND [ConfigurationName] = @ConfigurationName;

        IF EXISTS
            (
                SELECT
                    *
                FROM
                    [Configuration].[ValuePatient] AS [cvp]
                WHERE
                    [cvp].[TypeCode] = @TypeCode
                    AND [cvp].[ConfigurationName] = @ConfigurationName
            )
            DELETE
            [Configuration].[ValuePatient]
            WHERE
                [TypeCode] = @TypeCode
                AND [ConfigurationName] = @ConfigurationName;

        DECLARE @SqlQuery VARCHAR(2000);

        SET @SqlQuery
            = '
INSERT INTO [old].[cfgValuesFactory]
    (TypeCode
    ,ConfigurationName
    ,ConfigurationValue
    ,ValueType
    ,global_type
    ,ConfigurationXmlValue          
    )
SELECT ''' + @TypeCode + ''' AS [TypeCode], ''' + @ConfigurationName
              + ''' AS [ConfigurationName],
NULL AS [ConfigurationValue],
''xml'' AS [ValueType], ''' + @IsGlobal + ''' AS [global_type],
BulkColumn FROM OPENROWSET(bulk ''' + @Filename + ''', SINGLE_BLOB) AS [ConfigurationXmlValue]';

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateXmlValue';

