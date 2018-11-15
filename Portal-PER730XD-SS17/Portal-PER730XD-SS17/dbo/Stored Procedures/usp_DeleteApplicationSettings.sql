CREATE PROCEDURE [dbo].[usp_DeleteApplicationSettings]
    @applicationType VARCHAR(50),
    @instanceId VARCHAR(50) = '%', -- by default delete all
    @key VARCHAR(50) = '%' -- by default delete all
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE
        [as]
    FROM
        [dbo].[ApplicationSettings] AS [as]
    WHERE
        [as].[ApplicationType] = @applicationType
        AND [as].[InstanceId] LIKE @instanceId
        AND [as].[Key] LIKE @key;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stored procedure for removing all application settings for a specific ApplicationType and optionally filtered by instanceId and/or key. If instanceId is specified then only application settings for that specific instanceId will be deleted.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DeleteApplicationSettings';

