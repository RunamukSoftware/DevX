CREATE PROCEDURE [old].[uspSetConfigurationValues]
    (
        @KeyName  VARCHAR(40),
        @KeyValue VARCHAR(100)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[ConfigurationValue]
        SET
            [KeyValue] = @KeyValue
        WHERE
            [KeyName] = @KeyName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSetConfigurationValues';

