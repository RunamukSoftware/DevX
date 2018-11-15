CREATE PROCEDURE [dbo].[usp_GetApplicationSettings]
    @applicationType VARCHAR(50),
    @instanceId VARCHAR(50) = '%', -- by default return all
    @key VARCHAR(50) = '%' -- by default return all
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        [as].[ApplicationType],
        [as].[InstanceId],
        [as].[Key],
        [as].[Value]
    FROM
        [dbo].[ApplicationSettings] AS [as]
    WHERE
        [as].[ApplicationType] = @applicationType
        AND [as].[InstanceId] LIKE @instanceId
        AND [as].[Key] LIKE @key
    ORDER BY
        [as].[InstanceId];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve all application settings for a specific ApplicationType optionally filtered by instanceId and/or key.  If instanceId is specified then only application settings for that specific instanceId will be returned.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetApplicationSettings';

