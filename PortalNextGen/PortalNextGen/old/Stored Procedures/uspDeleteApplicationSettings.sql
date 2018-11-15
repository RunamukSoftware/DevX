CREATE PROCEDURE [old].[uspDeleteApplicationSettings]
    @ApplicationType VARCHAR(50),
    @InstanceID      VARCHAR(50) = '%', -- by default delete all
    @Key             VARCHAR(50) = '%'  -- by default delete all
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [as]
        FROM
            [old].[ApplicationSetting] AS [as]
        WHERE
            [as].[ApplicationType] = @ApplicationType
            AND [as].[InstanceID] LIKE @InstanceID
            AND [as].[Key] LIKE @Key;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stored procedure for removing all application settings for a specific ApplicationType and optionally filtered by instanceID and/or key. If instanceID is specified then only application settings for that specific instanceID will be deleted.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteApplicationSettings';

