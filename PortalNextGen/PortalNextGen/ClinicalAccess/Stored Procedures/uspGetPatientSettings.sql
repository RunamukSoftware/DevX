CREATE PROCEDURE [ClinicalAccess].[uspGetPatientSettings]
    (
        @PatientID INT,
        @UnitID    AS INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [cvp].[TypeCode]              AS [CFGTYPE],
                    [cvp].[ConfigurationName]     AS [CFGNAME],
                    [cvp].[ConfigurationValue]    AS [CFGVALUE],
                    [cvp].[ConfigurationXmlValue] AS [CFGXMLVALUE],
                    [cvp].[ValueType]             AS [VALUETYPE]
                FROM
                    [Configuration].[ValuePatient] AS [cvp]
                WHERE
                    [cvp].[PatientID] = @PatientID
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

                DECLARE --@PAT_TABLE VARCHAR(25) = 'cfgValuesPatient',
                    @UNIT_TABLE    VARCHAR(25) = 'cfgValuesUnit',
                    @FACTORY_TABLE VARCHAR(25) = 'cfgValuesFactory',
                    @GLOBAL_TABLE  VARCHAR(25) = 'cfgValuesGlobal',
                    @CURRENT       VARCHAR(25);

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
                                @UNIT_TABLE,
                                [cvu].[TypeCode],
                                [cvu].[ConfigurationName],
                                [cvu].[ConfigurationValue],
                                [cvu].[ConfigurationXmlValue],
                                [cvu].[ValueType]
                            FROM
                                [Configuration].[ValueUnit] AS [cvu]
                            WHERE
                                [cvu].[UnitID] = @UnitID;

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

                SET @CURRENT = @UNIT_TABLE;

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
                            [TableName] = @UNIT_TABLE
                    )
                    BEGIN
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
                            SET @CURRENT = @FACTORY_TABLE;
                    END;

                IF NOT EXISTS
                    (
                        SELECT
                            [cvp].[TypeCode]              AS [CFGTYPE],
                            [cvp].[ConfigurationName]     AS [CFGNAME],
                            [cvp].[ConfigurationValue]    AS [CFGVALUE],
                            [cvp].[ConfigurationXmlValue] AS [CFGXMLVALUE],
                            [cvp].[ValueType]             AS [VALUETYPE]
                        FROM
                            [Configuration].[ValuePatient] AS [cvp]
                        WHERE
                            [cvp].[PatientID] = @PatientID
                    )
                    BEGIN
                        INSERT INTO [Configuration].[ValuePatient]
                            (
                                [PatientID],
                                [TypeCode],
                                [ConfigurationName],
                                [ConfigurationValue],
                                [ConfigurationXmlValue],
                                [ValueType],
                                [Timestamp]
                            )
                                    SELECT
                                        @PatientID,
                                        [TypeCode],
                                        [ConfigurationName],
                                        [ConfigurationValue],
                                        [ConfigurationXmlValue],
                                        [ValueType],
                                        SYSUTCDATETIME()
                                    FROM
                                        @TEMP
                                    WHERE
                                        [TableName] = @CURRENT;
                    END;
            END;

        SELECT
            [cvp].[TypeCode]              AS [CFGTYPE],
            [cvp].[ConfigurationName]     AS [CFGNAME],
            [cvp].[ConfigurationValue]    AS [CFGVALUE],
            [cvp].[ConfigurationXmlValue] AS [CFGXMLVALUE],
            [cvp].[ValueType]             AS [VALUETYPE],
            CAST(0 AS BIT)                AS [GLOBALTYPE]
        FROM
            [Configuration].[ValuePatient] AS [cvp]
        WHERE
            [cvp].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the patient settings.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSettings';

