CREATE PROCEDURE [old].[uspGetPatientTimeOfDay]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7)
    )
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
            AND @StartDateTime >= [iw].[StartDateTime]
            AND @StartDateTime <= [iw].[EndDateTime]
        ORDER BY
            [iw].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform time of day given a starting file time.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientTimeOfDay';

