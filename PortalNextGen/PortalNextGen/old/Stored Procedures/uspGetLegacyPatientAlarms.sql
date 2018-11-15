CREATE PROCEDURE [old].[uspGetLegacyPatientAlarms]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7),
        @Locale        VARCHAR(7) = 'en'
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ia].[AlarmID],
            [ict].[ChannelCode]           AS [Type],
            ISNULL([ia].[AlarmCode], N'') AS [TypeString],
            ISNULL([ia].[AlarmCode], N'') AS [TITLE],
            [ia].[StartDateTime],
            [ia].[EndDateTime],
            [ia].[Removed],
            [ia].[AlarmLevel]             AS [Priority],
            CAST(N'' AS NVARCHAR(250))    AS [Label]
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
            AND [ia].[AlarmLevel] > 0
            AND (
                    @StartDateTime < [ia].[EndDateTime]
                    OR [ia].[EndDateTime] IS NULL
                )
        ORDER BY
            [ia].[StartDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get a list of alarms from a non enhanced tele patient', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientAlarms';

