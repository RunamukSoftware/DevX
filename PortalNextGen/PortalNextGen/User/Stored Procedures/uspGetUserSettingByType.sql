CREATE PROCEDURE [User].[uspGetUserSettingByType]
    (
        @UserID AS            INT,
        @ConfigurationName AS VARCHAR(40)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ius].[ConfigurationXmlValue]
        FROM
            [User].[Setting] AS [ius]
        WHERE
            [ius].[UserID] = @UserID
            AND [ius].[ConfigurationName] = @ConfigurationName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspGetUserSettingByType';

