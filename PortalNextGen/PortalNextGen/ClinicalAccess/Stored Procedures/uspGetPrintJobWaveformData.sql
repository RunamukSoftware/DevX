CREATE PROCEDURE [ClinicalAccess].[uspGetPrintJobWaveformData]
    (
        @PrintJobID INT,
        @PageNumber INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipjw].[WaveformType],
            [ipjw].[ChannelType],
            [ipjw].[label_min],
            [ipjw].[label_max],
            [ipjw].[show_units],
            [ipjw].[SequenceNumber],
            [ipjw].[annotation_channel_type],
            [ipjw].[offset],
            [ipjw].[scale],
            [ipjw].[primary_annotation],
            [ipjw].[WaveformData],
            [ipjw].[grid_type],
            [ipjw].[scale_labels],
            CAST(224 AS SMALLINT) AS [SampleRate] --Hard coding this for ML. When DL is integrated it should store and return apt sample rate for UVSL/ET etc.
        FROM
            [Intesys].[PrintJobWaveform] AS [ipjw]
        WHERE
            [ipjw].[PrintJobID] = @PrintJobID
            AND [ipjw].[PageNumber] = @PageNumber

        /*  This will need to be added back when UVSL print jobs are managed by DataLoader

    UNION ALL

    SELECT
        [WaveformType],
        [ChannelType],
        [label_min],
        [label_max],
        [show_units],
        [SequenceNumber],
        [annotation_channel_type],
        [offset],
        [scale],
        [primary_annotation],
        [WaveformData],
        [grid_type],
        [scale_labels],
        [SampleRate]
    FROM [old].[vwPrintJobsWaveform]
    WHERE [PrintJobID] = @PrintJobID
        AND [page_number] = @PageNumber;
*/
        ORDER BY
            [ipjw].[SequenceNumber];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetPrintJobWaveformData';

