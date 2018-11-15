CREATE PROCEDURE [old].[uspGetSavedEventWaveFormType]
    (
        @PatientID INT,
        @EventID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isew].[WaveformCategory] AS [WaveformType]
        FROM
            [Intesys].[SavedEventWaveform] AS [isew]
        WHERE
            [isew].[PatientID] = @PatientID
            AND [isew].[EventID] = @EventID
            AND [isew].[Visible] = 1
        ORDER BY
            [isew].[WaveformCategory] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSavedEventWaveFormType';

