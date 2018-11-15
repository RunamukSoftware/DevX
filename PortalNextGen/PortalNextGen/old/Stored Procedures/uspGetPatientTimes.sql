CREATE PROCEDURE [old].[uspGetPatientTimes] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MIN([iw].[StartDateTime]) AS [StartDateTime],
            MAX([iw].[EndDateTime])   AS [EndDateTime]
        FROM
            [Intesys].[PatientChannel] AS [ipc]
            INNER JOIN
                [Intesys].[Waveform]   AS [iw]
                    ON [ipc].[PatientChannelID] = [iw].[PatientChannelID]
        WHERE
            [ipc].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform starting and ending file times.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientTimes';

