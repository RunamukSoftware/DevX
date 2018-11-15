CREATE PROCEDURE [old].[uspSetLanguage] (@ICSLang VARCHAR(100))
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [cv].[KeyValue]
                FROM
                    [Intesys].[ConfigurationValue] AS [cv]
                WHERE
                    [cv].[KeyName] = 'Language'
            )
            BEGIN
                INSERT INTO [Intesys].[ConfigurationValue]
                    (
                        [KeyName],
                        [KeyValue]
                    )
                VALUES
                    (
                        'Language', @ICSLang
                    );
            END;
        ELSE
            UPDATE
                [Intesys].[ConfigurationValue]
            SET
                [KeyValue] = @ICSLang
            WHERE
                [KeyName] = 'Language';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSetLanguage';

