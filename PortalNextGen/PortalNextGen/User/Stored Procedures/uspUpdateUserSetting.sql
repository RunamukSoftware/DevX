CREATE PROCEDURE [User].[uspUpdateUserSetting]
    (
        @UserID                INT,
        @ConfigurationName     VARCHAR(40),
        @ConfigurationXmlValue XML
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [ius].[ConfigurationXmlValue]
                FROM
                    [User].[Setting] AS [ius]
                WHERE
                    [ius].[UserID] = @UserID
                    AND [ius].[ConfigurationName] = @ConfigurationName
            )
            BEGIN
                INSERT INTO [User].[Setting]
                    (
                        [UserID],
                        [ConfigurationXmlValue],
                        [ConfigurationName]
                    )
                VALUES
                    (
                        @UserID, @ConfigurationXmlValue, @ConfigurationName
                    );
            END;
        ELSE
            BEGIN
                UPDATE
                    [User].[Setting]
                SET
                    [ConfigurationXmlValue] = @ConfigurationXmlValue
                WHERE
                    [UserID] = @UserID
                    AND [ConfigurationName] = @ConfigurationName;

            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspUpdateUserSetting';

