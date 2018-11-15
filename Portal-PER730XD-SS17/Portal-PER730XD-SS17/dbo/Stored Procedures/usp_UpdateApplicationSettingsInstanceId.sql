CREATE PROCEDURE [dbo].[usp_UpdateApplicationSettingsInstanceId]
    @applicationType VARCHAR(50),
    @oldInstanceId VARCHAR(50),
    @newInstanceId VARCHAR(50)
AS
BEGIN
    UPDATE
        [dbo].[ApplicationSettings]
    SET
        [InstanceId] = @newInstanceId
    WHERE
        [InstanceId] = @oldInstanceId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Updates an the instance Id for a group of application settings in the database.  @applicationType: The application type of the instance id to update.  @oldInstanceId: The instance Id to update.  @newInstanceId: The new instance Id to replace the old one with', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateApplicationSettingsInstanceId';

