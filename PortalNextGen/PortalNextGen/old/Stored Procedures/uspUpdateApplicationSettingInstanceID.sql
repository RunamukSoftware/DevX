CREATE PROCEDURE [old].[uspUpdateApplicationSettingInstanceID]
    @ApplicationType VARCHAR(50),
    @OldInstanceID   VARCHAR(50),
    @NewInstanceID   VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [old].[ApplicationSetting]
        SET
            [InstanceID] = @NewInstanceID
        WHERE
            [ApplicationType] = @ApplicationType
            AND [InstanceID] = @OldInstanceID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Updates an the instance ID for a group of application settings in the database.  @ApplicationType: The application Type of the instance id to update.  @OldInstanceID: The instance ID to update.  @NewInstanceID: The new instance ID to replace the old one.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateApplicationSettingInstanceID';

