-- TODO: Just seperated the Legacy and Enhanced Telemetry (ET). This need optimized.
CREATE PROCEDURE [old].[uspGetLegacyPatientVitalSignByChannels]
    (
        @PatientID    INT,
        @ChannelTypes [old].[utpStringList] READONLY
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @VitalValue [old].[utpVitalValue];

        INSERT INTO @VitalValue
            (
                [VitalValue]
            )
                    SELECT
                        [ivl].[VitalValue]
                    FROM
                        [Intesys].[VitalLive] AS [ivl]
                    WHERE
                        [ivl].[PatientID] = @PatientID;
        ((SELECT
                  [PATCHL].[ChannelTypeID]  AS [PatientChannelID],
                  [MSCODE].[Code]           AS [GlobalDataSystemCode],
                  [LiveValue].[ResultValue] AS [VitalValue],
                  [CHVIT].[FormatString]    AS [FormatString]
          FROM
                  [Intesys].[PatientChannel]    AS [PATCHL]
              INNER JOIN
                  [Intesys].[ChannelVital]      AS [CHVIT]
                      ON [PATCHL].[ChannelTypeID] = [CHVIT].[ChannelTypeID]
                         AND [PATCHL].[ActiveSwitch] = 1
              INNER JOIN
                  [Intesys].[VitalLive]         AS [VITALRES]
                      ON [PATCHL].[PatientID] = [VITALRES].[PatientID]
              LEFT OUTER JOIN
                  (
                      SELECT
                          [idx],
                          [value],
                          SUBSTRING([value], CHARINDEX('=', [value]) + 1, LEN([value])) AS [ResultValue],
                          CONVERT(INT, SUBSTRING([value], 0, CHARINDEX('=', [value])))  AS [GlobalDataSystemCodeID]
                      FROM
                          [old].[ufnVitalMerge]((@VitalValue), '|')
                  )                             AS [LiveValue]
                      ON [LiveValue].[GlobalDataSystemCodeID] = [CHVIT].[GlobalDataSystemCodeID]
              LEFT OUTER JOIN
                  [Intesys].[MiscellaneousCode] AS [MSCODE]
                      ON [MSCODE].[CodeID] = [CHVIT].[GlobalDataSystemCodeID]
                         AND [MSCODE].[Code] IS NOT NULL
          WHERE
                  [PATCHL].[PatientID] = @PatientID
                  AND [PATCHL].[ChannelTypeID] IN (
                                                      SELECT
                                                          [Item]
                                                      FROM
                                                          @ChannelTypes
                                                  )
                  AND [PATCHL].[ActiveSwitch] = 1
                  AND [LiveValue].[idx] IS NOT NULL))
        ORDER BY
            [VitalValue];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientVitalSignByChannels';

