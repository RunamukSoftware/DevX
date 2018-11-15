CREATE PROCEDURE [old].[uspGetLegacyPatientWaveFormTimeHistory] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iw].[StartDateTime]
        FROM
            [Intesys].[PatientChannel] AS [ipc]
            INNER JOIN
                [Intesys].[Waveform]   AS [iw]
                    ON [ipc].[PatientChannelID] = [iw].[PatientChannelID]
        WHERE
            [ipc].[PatientID] = @PatientID
        ORDER BY
            [iw].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientWaveFormTimeHistory';

