CREATE PROCEDURE [dbo].[SaveEventWaveForm]
    @patient_id UNIQUEIDENTIFIER,
    @event_id UNIQUEIDENTIFIER,
    @wave_index INT,
    @waveform_category INT,
    @lead INT,
    @resolution INT,
    @height INT,
    @waveform_type INT,
    @visible TINYINT,
    @channel_id UNIQUEIDENTIFIER,
    @scale FLOAT,
    @scale_type INT,
    @scale_min INT,
    @scale_max INT,
    @duration INT,
    @sample_rate INT,
    @sample_count BIGINT,
    @num_Ypoints INT,
    @baseline INT,
    @Ypoints_per_unit FLOAT,
    @waveform_data IMAGE,
    @waveform_color VARCHAR(50),
    @scale_unit_type INT
AS
BEGIN
    INSERT  INTO [dbo].[int_savedevent_waveform]
            ([patient_id],
             [event_id],
             [wave_index],
             [waveform_category],
             [lead],
             [resolution],
             [height],
             [waveform_type],
             [visible],
             [channel_id],
             [scale],
             [scale_type],
             [scale_min],
             [scale_max],
             [duration],
             [sample_rate],
             [sample_count],
             [num_Ypoints],
             [baseline],
             [Ypoints_per_unit],
             [waveform_data],
             [num_timelogs],
             [waveform_color],
             [scale_unit_type]
            )
    VALUES
            (@patient_id,
             @event_id,
             @wave_index,
             @waveform_category,
             @lead,
             @resolution,
             @height,
             @waveform_type,
             @visible,
             @channel_id,
             @scale,
             @scale_type,
             @scale_min,
             @scale_max,
             @duration,
             @sample_rate,
             @sample_count,
             @num_Ypoints,
             @baseline,
             @Ypoints_per_unit,
             @waveform_data,
             0, --@num_timelogs
             @waveform_color,
             @scale_unit_type
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SaveEventWaveForm';

