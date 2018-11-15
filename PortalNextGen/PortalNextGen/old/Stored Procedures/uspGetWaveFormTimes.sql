CREATE PROCEDURE [old].[uspGetWaveFormTimes]
    (
        @PatientID    INT,
        @Channel1Code SMALLINT,
        @Channel2Code SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @Channel1CodeString VARCHAR(MAX),
            @Channel2CodeString VARCHAR(MAX);

        -- Convert to appropriate types to avoid implicit conversions.
        SELECT
            @Channel1CodeString = CAST(@Channel1Code AS VARCHAR(30)),
            @Channel2CodeString = CAST(@Channel2Code AS VARCHAR(30));

        SELECT
            MIN([iw].[StartDateTime]) AS [StartDateTime],
            MAX([iw].[EndDateTime])   AS [EndDateTime],
            [ict].[ChannelCode],
            [ict].[ChannelTypeID]
        FROM
            [Intesys].[Waveform]           AS [iw]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [iw].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND (
                    [ict].[ChannelCode] = @Channel1Code
                    OR [ict].[ChannelCode] = @Channel2Code
                )
        GROUP BY
            [ict].[ChannelCode],
            [ict].[ChannelTypeID]
        UNION ALL
        SELECT
            MIN([vlw].[StartDateTime]) AS [StartDateTime],
            MAX([vlw].[EndDateTime])   AS [EndDateTime],
            [vlct].[ChannelCode],
            [vlct].[TypeID]            AS [ChannelTypeID]
        FROM
            [old].[vwLegacyWaveform]           AS [vlw]
            INNER JOIN
                [old].[vwPatientChannelLegacy] AS [vpcl]
                    ON [vlw].[TypeID] = [vpcl].[TypeID]
                       AND [vlw].[TopicTypeID] = [vpcl].[TopicTypeID] -- Added to help join performance
                       AND [vlw].[DeviceSessionID] = [vpcl].[DeviceSessionID] -- Added to help join performance
            INNER JOIN
                [old].[vwLegacyChannelTypes]   AS [vlct]
                    ON [vpcl].[TypeID] = [vlct].[TypeID]
                       AND [vlw].[TopicTypeID] = [vlct].[TopicTypeID] -- Added to help join performance
                       AND [vpcl].[TopicTypeID] = [vlct].[TopicTypeID] -- Added to help join performance
                       AND [vpcl].[ChannelTypeID] = [vlct].[ChannelTypeID] -- Added to help join performance
        WHERE
            [vlw].[PatientID] = @PatientID
            AND (
                    [vlct].[ChannelCode] = @Channel1CodeString -- Remove implicit conversion by using appropriate data Type
                    OR [vlct].[ChannelCode] = @Channel2CodeString
                ) -- Remove implicit conversion by using appropriate data Type
        GROUP BY
            [vlct].[ChannelCode],
            [vlct].[TypeID]
        ORDER BY
            [ict].[ChannelCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform times for analysis service given 2 channel codes.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetWaveFormTimes';

