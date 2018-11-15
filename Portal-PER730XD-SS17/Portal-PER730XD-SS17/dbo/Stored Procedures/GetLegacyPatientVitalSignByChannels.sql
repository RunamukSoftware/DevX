-- TODO: Just seperated the Legacy and ET. This need optimized.
CREATE PROCEDURE [dbo].[GetLegacyPatientVitalSignByChannels]
    (
     @PatientId UNIQUEIDENTIFIER,
     @ChannelTypes [dbo].[StringList] READONLY
    )
AS
BEGIN
    DECLARE @VitalValue [dbo].[VitalValues];

    INSERT  INTO @VitalValue
    SELECT
        [vital_value]
    FROM
        [dbo].[int_vital_live]
    WHERE
        [patient_id] = @PatientId;
    ((SELECT
        [PATCHL].[channel_type_id] AS [PATIENT_CHANNEL_ID],
        [MSCODE].[code] AS [GDS_CODE],
        [LiveValue].[ResultValue] AS [VITAL_VALUE],
        [CHVIT].[format_string] AS [FORMAT_STRING]
      FROM
        [dbo].[int_patient_channel] AS [PATCHL]
        INNER JOIN [dbo].[int_channel_vital] AS [CHVIT] ON [PATCHL].[channel_type_id] = [CHVIT].[channel_type_id]
                                                           AND [PATCHL].[active_sw] = 1
        INNER JOIN [dbo].[int_vital_live] AS [VITALRES] ON [PATCHL].[patient_id] = [VITALRES].[patient_id]
        LEFT OUTER JOIN (SELECT
                            [idx],
                            [value],
                            SUBSTRING([value], CHARINDEX('=', [value]) + 1, LEN([value])) AS [ResultValue],
                            CONVERT(INT, SUBSTRING([value], 0, CHARINDEX('=', [value]))) AS [GdsCodeId]
                         FROM
                            [dbo].[fn_Vital_Merge]((@VitalValue), '|')
                        ) AS [LiveValue] ON [LiveValue].[GdsCodeId] = [CHVIT].[gds_cid]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [MSCODE] ON [MSCODE].[code_id] = [CHVIT].[gds_cid]
                                                             AND [MSCODE].[code] IS NOT NULL
      WHERE
        [PATCHL].[patient_id] = @PatientId
        AND [PATCHL].[channel_type_id] IN (SELECT
                                            [Item]
                                           FROM
                                            @ChannelTypes)
        AND [PATCHL].[active_sw] = 1
        AND [LiveValue].[idx] IS NOT NULL)
    )
    ORDER BY
        [VITAL_VALUE];
END;
