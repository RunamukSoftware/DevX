CREATE PROCEDURE [old].[uspRetrieveConfigurationSection]
    (
        @ApplicationName NVARCHAR(256),
        @SectionName     NVARCHAR(256)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [SectionData],
            [UpdatedDateTime]
        FROM
            [Configuration].[Configuration]
        WHERE
            [ApplicationName] = @ApplicationName
            AND [SectionName] = @SectionName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve Configuration data', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrieveConfigurationSection';

