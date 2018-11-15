CREATE PROCEDURE [old].[uspGetPatientAlarmsByType]
    (
        @PatientID     INT,
        @AlarmType    INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ia].[AlarmID],
            [ia].[AlarmCode]     AS [TITLE],
            [ia].[StartDateTime] AS [StartDateTime],
            [ia].[EndDateTime]   AS [EndDateTime],
            [ia].[StartDateTime] AS [StartDateTime],
            [ia].[Removed],
            [ia].[AlarmLevel]    AS [priority]
        FROM
            [Intesys].[Alarm]              AS [ia]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [ia].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ia].[PatientID] = @PatientID
            AND [ict].[ChannelCode] = @AlarmType
            AND (
                    (
                        @StartDateTime < [ia].[EndDateTime]
                        AND @EndDateTime >= [ia].[StartDateTime]
                    )
                    OR (
                           @EndDateTime >= [ia].[StartDateTime]
                           AND [ia].[EndDateTime] IS NULL
                       )
                )
        ORDER BY
            [ia].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientAlarmsByType';

