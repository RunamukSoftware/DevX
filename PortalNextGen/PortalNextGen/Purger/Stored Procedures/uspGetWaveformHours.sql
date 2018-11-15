CREATE PROCEDURE [Purger].[uspGetWaveformHours]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [is].[Setting]
        FROM
            [Intesys].[SystemGeneration] AS [is]
        WHERE
            [is].[ProductCode] = 'fulldiscl'
            AND [is].[FeatureCode] = 'NUMBER_OF_HOURS';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge Waveform Hours.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspGetWaveformHours';

