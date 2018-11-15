CREATE PROCEDURE [dbo].[usp_AddApplicationSettings]
    @applicationSettings [dbo].[KeyValueTableType] READONLY
AS
BEGIN 
    SET NOCOUNT ON;

    MERGE INTO [dbo].[ApplicationSettings] AS [TARGET]
    USING @applicationSettings AS [NEWDATA]
    ON [TARGET].[ApplicationType] = [NEWDATA].[ApplicationType]
        AND [TARGET].[InstanceId] = [NEWDATA].[InstanceId]
        AND [TARGET].[Key] = [NEWDATA].[Key]
    WHEN MATCHED THEN -- Update the value of keys that are already present
        UPDATE SET
               [TARGET].[Value] = [NEWDATA].[Value]
    WHEN NOT MATCHED THEN -- Add new row if key is not present 
        INSERT
               ([ApplicationType],
                [InstanceId],
                [Key],
                [Value])
        VALUES ([NEWDATA].[ApplicationType],
                [NEWDATA].[InstanceId],
                [NEWDATA].[Key],
                [NEWDATA].[Value]);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add application settings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AddApplicationSettings';

