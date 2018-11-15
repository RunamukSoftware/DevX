CREATE PROCEDURE [TechSupport].[uspChannelInformation]
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @ActiveChannels AS         INT,
            @ActiveWaveformChannels AS INT;

        SELECT
            @ActiveChannels = COUNT(*)
        FROM
            [Intesys].[PatientChannel] AS [ipc]
            LEFT OUTER JOIN
                [Intesys].[Monitor]    AS [im]
                    ON [ipc].[MonitorID] = [im].[MonitorID]
        WHERE
            [ipc].[ActiveSwitch] = 1
            AND [im].[MonitorID] IS NOT NULL;

        SELECT
            @ActiveWaveformChannels = COUNT(*)
        FROM
            [Intesys].[PatientChannel]  AS [ipc]
            LEFT OUTER JOIN
                [Intesys].[Monitor]     AS [im]
                    ON [ipc].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[ChannelType] AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ipc].[ActiveSwitch] = 1
            AND [im].[MonitorID] IS NOT NULL
            AND [ict].[TypeCode] = 'WAVEFORM';

        SELECT
            @ActiveChannels         AS [ACTIVE_CHANNELS],
            @ActiveWaveformChannels AS [ACTIVE_WAVEFORM_CHANNELS];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'PROCEDURE', @level1name = N'uspChannelInformation';

