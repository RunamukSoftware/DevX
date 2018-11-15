CREATE PROCEDURE [old].[uspGetLanguage]
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @KeyValue NVARCHAR(100);

        SELECT
            @KeyValue = [icv].[KeyValue]
        FROM
            [Intesys].[ConfigurationValue] AS [icv]
        WHERE
            [icv].[KeyName] = 'Language';

        IF (@KeyValue = '')
            BEGIN
                UPDATE
                    [Intesys].[ConfigurationValue]
                SET
                    [KeyValue] = 'ENU'
                WHERE
                    [KeyName] = 'Language';

                SET @KeyValue = 'ENU';
            END;
        ELSE IF (@KeyValue IS NULL)
                 BEGIN
                     INSERT INTO [Intesys].[ConfigurationValue]
                         (
                             [KeyName],
                             [KeyValue]
                         )
                     VALUES
                         (
                             'Language', 'ENU'
                         );

                     SET @KeyValue = 'ENU';
                 END;

        SELECT
            @KeyValue AS [keyvalue];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLanguage';

