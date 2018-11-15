CREATE PROCEDURE [old].[uspAddApplicationSettings] @ApplicationSettings [old].[utpKeyValueTable] READONLY
AS
    BEGIN
        SET NOCOUNT ON;

        MERGE INTO [old].[ApplicationSetting] AS [target]
        USING @ApplicationSettings AS [newdata]
        ON [target].[ApplicationType] = [newdata].[ApplicationType]
           AND [target].[InstanceID] = [newdata].[InstanceID]
           AND [target].[Key] = [newdata].[Key]
        WHEN MATCHED THEN -- Update the value of keys that are already present
        UPDATE SET
            [target].[Value] = [newdata].[Value]
        WHEN NOT MATCHED
            THEN -- Add new row if key is not present 
        INSERT
            (
                [ApplicationType],
                [InstanceID],
                [Key],
                [Value]
            )
        VALUES
            (
                [newdata].[ApplicationType], [newdata].[InstanceID], [newdata].[Key], [newdata].[Value]
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add application settings.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspAddApplicationSettings';

