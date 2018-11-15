CREATE PROCEDURE [old].[uspGetLegacyPatientChannelTimes] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MIN([iw].[StartDateTime]) AS [MinStartDateTime],
            MAX([iw].[EndDateTime])   AS [MaxEndDateTime],
            [ict].[ChannelCode],
            NULL                      AS [Label],
            [ict].[Priority],
            [ict].[ChannelTypeID],
            [ict].[Frequency]         AS [SampleRate]
        FROM
            [Intesys].[Waveform]           AS [iw]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [iw].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ipc].[PatientID] = @PatientID
        GROUP BY
            [ict].[ChannelCode],
            [ict].[Label],
            [ict].[Priority],
            [ict].[ChannelTypeID],
            [ict].[Frequency]
        ORDER BY
            [ict].[Priority];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the legacy patient channel times.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientChannelTimes';

