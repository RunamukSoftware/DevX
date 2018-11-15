CREATE PROCEDURE [dbo].[GetWaveFormTimes]
    (
     @PatientID [dbo].[DPATIENT_ID],
     @Channel1Code SMALLINT,
     @Channel2Code SMALLINT
    )
AS
BEGIN
    DECLARE
        @PatientIDGUID UNIQUEIDENTIFIER,
        @Channel1CodeString VARCHAR(30),
        @Channel2CodeString VARCHAR(30);

    -- Convert to appropriate types to avoid implicit conversions.
    SELECT
        @PatientIDGUID = CAST(@PatientID AS UNIQUEIDENTIFIER),
        @Channel1CodeString = CAST(@Channel1Code AS VARCHAR(30)),
        @Channel2CodeString = CAST(@Channel2Code AS VARCHAR(30));

    SELECT
        MIN([wvfrm].[start_ft]) AS [start_time],
        MAX([wvfrm].[end_ft]) AS [end_time],
        [ct].[channel_code],
        [ct].[channel_type_id]
    FROM
        [dbo].[int_waveform] AS [wvfrm]
        INNER JOIN [dbo].[int_patient_channel] AS [pc]
            ON [wvfrm].[patient_channel_id] = [pc].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type] AS [ct]
            ON [pc].[channel_type_id] = [ct].[channel_type_id]
    WHERE
        [wvfrm].[patient_id] = @PatientIDGUID
        AND ([ct].[channel_code] = @Channel1Code
             OR [ct].[channel_code] = @Channel2Code)
    GROUP BY
        [ct].[channel_code],
        [ct].[channel_type_id]

    UNION ALL

    SELECT
        MIN([vlw].[FileTimeStampBeginUTC]) AS [start_time],
        MAX([vlw].[FileTimeStampEndUTC]) AS [end_time],
        [vlct].[ChannelCode] AS [channel_code],
        [vlct].[TypeId] AS [channel_type_id]
    FROM
        [dbo].[v_LegacyWaveform] AS [vlw]
        INNER JOIN [dbo].[v_PatientChannelLegacy] AS [vpcl]
            ON [vlw].[TypeId] = [vpcl].[TypeId]
               AND [vlw].[TopicTypeId] = [vpcl].[TopicTypeId] -- Added to help join performance
               AND [vlw].[DeviceSessionId] = [vpcl].[DeviceSessionId] -- Added to help join performance
        INNER JOIN [dbo].[v_LegacyChannelTypes] AS [vlct]
            ON [vpcl].[TypeId] = [vlct].[TypeId]
               AND [vlw].[TopicTypeId] = [vlct].[TopicTypeId] -- Added to help join performance
               AND [vpcl].[TopicTypeId] = [vlct].[TopicTypeId] -- Added to help join performance
               AND [vpcl].[ChannelTypeId] = [vlct].[ChannelTypeId] -- Added to help join performance
    WHERE
        [vlw].[PatientId] = @PatientIDGUID
        AND ([vlct].[ChannelCode] = @Channel1CodeString -- Remove implicit conversion by using appropriate data type
             OR [vlct].[ChannelCode] = @Channel2CodeString) -- Remove implicit conversion by using appropriate data type
    GROUP BY
        [vlct].[ChannelCode],
        [vlct].[TypeId]

    ORDER BY
        [ct].[channel_code];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform times for analysis service given 2 channel codes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetWaveFormTimes';

