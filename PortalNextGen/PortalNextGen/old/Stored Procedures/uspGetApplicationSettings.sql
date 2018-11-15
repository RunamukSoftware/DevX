CREATE PROCEDURE [old].[uspGetApplicationSettings]
    @ApplicationType VARCHAR(50),
    @InstanceID      VARCHAR(50) = '%', -- by default return all
    @Key             VARCHAR(50) = '%'  -- by default return all
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [as].[ApplicationType],
            [as].[InstanceID],
            [as].[Key],
            [as].[Value]
        FROM
            [old].[ApplicationSetting] AS [as]
        WHERE
            [as].[ApplicationType] = @ApplicationType
            AND [as].[InstanceID] LIKE @InstanceID
            AND [as].[Key] LIKE @Key
        ORDER BY
            [as].[InstanceID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve all application settings for a specific ApplicationType optionally filtered by instanceID and/or key.  If instanceID is specified then only application settings for that specific instance ID will be returned.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetApplicationSettings';

