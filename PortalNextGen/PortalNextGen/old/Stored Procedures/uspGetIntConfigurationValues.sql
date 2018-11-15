CREATE PROCEDURE [old].[uspGetIntConfigurationValues] (@KeyName VARCHAR(40))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [icv].[KeyValue] AS [KEY_VALUE]
        FROM
            [Intesys].[ConfigurationValue] AS [icv]
        WHERE
            [icv].[KeyName] = @KeyName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetIntConfigurationValues';

