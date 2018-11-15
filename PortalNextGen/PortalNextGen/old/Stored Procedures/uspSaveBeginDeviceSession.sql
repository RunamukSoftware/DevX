CREATE PROCEDURE [old].[uspSaveBeginDeviceSession] (@BeginDeviceSessionData [old].[utpDeviceSessionData] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        -- Add devices that are not in the DB yet
        INSERT INTO [old].[Device]
            (
                [DeviceID],
                [Name]
            )
                    SELECT DISTINCT
                        [DeviceID],
                        [UniqueDeviceName]
                    FROM
                        @BeginDeviceSessionData
                    WHERE
                        NOT EXISTS
                        (
                            SELECT
                                *
                            FROM
                                [old].[Device]
                            WHERE
                                [DeviceID] = [@BeginDeviceSessionData].[DeviceID]
                        );

        -- If some of the devices have pending sessions, close them
        UPDATE
            [old].[DeviceSession]
        SET
            [EndDateTime] = [x].[BeginDateTime]
        FROM
            (
                SELECT
                    [ds].[DeviceSessionID],
                    [dd].[BeginDateTime]
                FROM
                    [old].[DeviceSession]       AS [ds]
                    INNER JOIN
                        @BeginDeviceSessionData AS [dd]
                            ON [ds].[DeviceID] = [dd].[DeviceID]
                               AND [ds].[EndDateTime] IS NULL
            ) AS [x]
        WHERE
            [x].[DeviceSessionID] = [DeviceSession].[DeviceSessionID];

        -- Add the new session rows
        MERGE INTO [old].[DeviceSession] AS [Target]
        USING @BeginDeviceSessionData AS [Source]
        ON [Source].[DeviceSessionID] = [Target].[DeviceSessionID]
        WHEN NOT MATCHED BY TARGET
            THEN INSERT
                     (
                         [DeviceSessionID],
                         [DeviceID],
                         [BeginDateTime]
                     )
                 VALUES
                     (
                         [Source].[DeviceSessionID], [Source].[DeviceID], [Source].[BeginDateTime]
                     )
        WHEN MATCHED
            THEN UPDATE SET
                     [Target].[DeviceID] = [Source].[DeviceID],
                     [Target].[BeginDateTime] = [Source].[BeginDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveBeginDeviceSession';

