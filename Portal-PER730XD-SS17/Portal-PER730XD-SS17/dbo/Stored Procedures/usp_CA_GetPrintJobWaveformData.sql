CREATE PROCEDURE [dbo].[usp_CA_GetPrintJobWaveformData]
    (
     @print_job_id UNIQUEIDENTIFIER,
     @page_number INT
    )
AS
BEGIN
    SELECT
        [waveform_type],
        [channel_type],
        [label_min],
        [label_max],
        [show_units],
        [seq_no],
        [annotation_channel_type],
        [offset],
        [scale],
        [primary_annotation],
        [waveform_data],
        [grid_type],
        [scale_labels],
        CAST(224 AS SMALLINT) AS [SAMPLE_RATE] --Hard coding this for ML. When DL is integrated it should store and return apt sample rate for UVSL/ET etc.
    FROM
        [dbo].[int_print_job_waveform]
    WHERE
        [print_job_id] = @print_job_id
        AND [page_number] = @page_number

/*  This will need to be added back when UVSL print jobs are managed by DataLoader

    UNION ALL

    SELECT
        [waveform_type],
        [channel_type],
        [label_min],
        [label_max],
        [show_units],
        [seq_no],
        [annotation_channel_type],
        [offset],
        [scale],
        [primary_annotation],
        [waveform_data],
        [grid_type],
        [scale_labels],
        [sample_rate]
    FROM [dbo].[v_PrintJobsWaveform]
    WHERE [print_job_id] = @print_job_id
        AND [page_number] = @page_number;
*/
    ORDER BY
        [seq_no];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetPrintJobWaveformData';

