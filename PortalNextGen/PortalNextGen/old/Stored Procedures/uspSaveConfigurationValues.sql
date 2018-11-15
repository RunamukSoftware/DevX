CREATE PROCEDURE [old].[uspSaveConfigurationValues]
    (
        @KeyName  VARCHAR(40),
        @KeyValue VARCHAR(100)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [KeyName]
                FROM
                    [Intesys].[ConfigurationValue]
                WHERE
                    [KeyName] = @KeyName
            )
            INSERT INTO [Intesys].[ConfigurationValue]
                (
                    [KeyName],
                    [KeyValue]
                )
            VALUES
                (
                    @KeyName, @KeyValue
                );
        ELSE
            UPDATE
                [Intesys].[ConfigurationValue]
            SET
                [KeyValue] = @KeyValue
            WHERE
                [KeyName] = @KeyName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveConfigurationValues';

