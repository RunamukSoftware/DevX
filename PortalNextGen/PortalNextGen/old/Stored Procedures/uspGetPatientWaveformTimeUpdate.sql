CREATE PROCEDURE [old].[uspGetPatientWaveformTimeUpdate]
    (
        @PatientID     INT,
        @AfterDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iw].[StartDateTime],
            [iw].[StartDateTime]
        FROM
            [Intesys].[PatientChannel] AS [ipc]
            INNER JOIN
                [Intesys].[Waveform]   AS [iw]
                    ON [ipc].[PatientChannelID] = [iw].[PatientChannelID]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND [iw].[StartDateTime] > @AfterDateTime
        ORDER BY
            [iw].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform starting time and file time after a specified file time.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientWaveformTimeUpdate';

