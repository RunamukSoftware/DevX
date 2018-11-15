CREATE PROCEDURE [old].[uspSaveEndDeviceSession] (@EndDeviceSession [old].[utpDeviceSessionData] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        /* We close all open topics still open on the device sessions that we are closing */
        DECLARE @ClosedDeviceSessions AS TABLE
            (
                [DeviceSessionID] INT          NOT NULL,
                [EndDateTime]     DATETIME2(7) NOT NULL
            );

        INSERT INTO @ClosedDeviceSessions
            (
                [DeviceSessionID],
                [EndDateTime]
            )
                    SELECT
                            [ds].[DeviceSessionID],
                            [dd].[EndDateTime]
                    FROM
                            [old].[DeviceSession] AS [ds]
                        INNER JOIN
                            @EndDeviceSession     AS [dd]
                                ON [ds].[DeviceSessionID] = [dd].[DeviceSessionID]
                                   AND [ds].[EndDateTime] IS NULL;

        UPDATE
            [old].[TopicSession]
        SET
            [EndDateTime] = [x].[EndDateTime]
        FROM
            @ClosedDeviceSessions AS [x]
        WHERE
            [TopicSession].[DeviceSessionID] = [x].[DeviceSessionID]
            AND [TopicSession].[EndDateTime] IS NULL;

        MERGE INTO [old].[DeviceSession] AS [Target]
        USING @EndDeviceSession AS [Source]
        ON [Source].[DeviceSessionID] = [Target].[DeviceSessionID]
        WHEN NOT MATCHED BY TARGET
            THEN INSERT
                     (
                         [DeviceSessionID],
                         [DeviceID],
                         [EndDateTime]
                     )
                 VALUES
                     (
                         [Source].[DeviceSessionID], [Source].[DeviceID], [Source].[EndDateTime]
                     )
        WHEN MATCHED
            THEN UPDATE SET
                     [Target].[EndDateTime] = [Source].[EndDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEndDeviceSession';

