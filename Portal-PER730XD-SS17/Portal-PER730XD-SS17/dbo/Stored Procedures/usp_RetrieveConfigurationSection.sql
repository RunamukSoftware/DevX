CREATE PROCEDURE [dbo].[usp_RetrieveConfigurationSection]
    (
     @ApplicationName NVARCHAR(256),
     @SectionName NVARCHAR(256)
    )
AS
BEGIN
    SELECT
        [SectionData],
        [UpdatedTimeStampUTC]
    FROM
        [dbo].[tbl_ConfigurationData]
    WHERE
        [ApplicationName] = @ApplicationName
        AND [SectionName] = @SectionName;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve Configuration data', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RetrieveConfigurationSection';

