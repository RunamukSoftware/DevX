CREATE PROCEDURE [dbo].[usp_SaveBeginDeviceSession]
    (
     @beginDeviceSessionData [dbo].DeviceSessionDataType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    -- Add devices that are not in the DB yet
    INSERT  INTO [dbo].[Devices]
            ([Id],
             [Name]
            )
    SELECT DISTINCT
        [DeviceId],
        [UniqueDeviceName]
    FROM
        @beginDeviceSessionData
    WHERE
        NOT EXISTS ( SELECT
                        *
                     FROM
                        [dbo].[Devices]
                     WHERE
                        [Id] = [@beginDeviceSessionData].[DeviceId] );

    -- If some of the devices have pending sessions, close them
    UPDATE
        [dbo].[DeviceSessions]
    SET
        [EndTimeUTC] = [x].[BeginTimeUTC]
    FROM
        (SELECT
            [ss].[Id],
            [dd].[BeginTimeUTC]
         FROM
            [dbo].[DeviceSessions] AS [ss]
            INNER JOIN @beginDeviceSessionData AS [dd] ON [ss].[DeviceId] = [dd].[DeviceId]
                                                          AND [ss].[EndTimeUTC] IS NULL
        ) AS [x]
    WHERE
        [x].[Id] = [DeviceSessions].[Id];
    
    -- Add the new session rows
    MERGE INTO [dbo].[DeviceSessions] AS [Target]
    USING @beginDeviceSessionData AS [Source]
    ON [Source].[Id] = [Target].[Id]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT
               ([Id],
                [DeviceId],
                [BeginTimeUTC]
               )
        VALUES ([Source].[Id],
                [Source].[DeviceId],
                [Source].[BeginTimeUTC]
               )
    WHEN MATCHED THEN
        UPDATE SET
               [Target].[DeviceId] = [Source].[DeviceId],
               [Target].[BeginTimeUTC] = [Source].[BeginTimeUTC];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveBeginDeviceSession';

