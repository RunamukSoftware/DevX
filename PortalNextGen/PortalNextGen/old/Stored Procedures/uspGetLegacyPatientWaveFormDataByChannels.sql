CREATE PROCEDURE [old].[uspGetLegacyPatientWaveFormDataByChannels]
    (
        @ChannelTypes [old].[utpStringList] READONLY,
        @PatientID    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipc].[ChannelTypeID] AS [PatientChannelID],
            [ipc].[PatientMonitorID],
            [iwl].[StartDateTime],
            [iwl].[EndDateTime],
            [iwl].[CompressMethod],
            [iwl].[WaveformData],
            NULL                  AS [TOPIC_INSTANCEID]
        FROM
            [Intesys].[PatientChannel]   AS [ipc]
            LEFT OUTER JOIN
                [Intesys].[WaveformLive] AS [iwl]
                    ON [iwl].[PatientChannelID] = [ipc].[PatientChannelID]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND [ipc].[ChannelTypeID] IN (
                                             SELECT
                                                 [Item]
                                             FROM
                                                 @ChannelTypes
                                         )
            AND [ipc].[ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientWaveFormDataByChannels';

