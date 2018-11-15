CREATE PROCEDURE [old].[uspGetProcessedStatisticsList]
    (
        @PatientID     INT,
        @TimeTagType   INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        WITH [Temp]
        AS (   SELECT
                   [ipt].[ParamDateTime] AS [StartDateTime],
                   [ipt].[Value1],
                   CAST(224 AS SMALLINT) AS [SampleRate],
                   [ipt].[PatientChannelID],
                   [ipt].[PatientID]
               FROM
                   [Intesys].[ParameterTimeTag] AS [ipt]
               WHERE
                   [ipt].[PatientID] = @PatientID
                   AND [ipt].[TimeTagType] = @TimeTagType
                   AND [ipt].[ParamDateTime]
                   BETWEEN @StartDateTime AND @EndDateTime)
        SELECT
            [Temp].[StartDateTime] AS [paramDateTime],
            [Temp].[Value1],
            [Temp].[SampleRate],
            [Temp].[PatientChannelID]
        FROM
            [Temp]
            LEFT OUTER JOIN
                [old].[vwDiscardedOverlappingLegacyWaveformData] AS [Discarded]
                    ON [Discarded].[PatientChannelID] = [Temp].[PatientChannelID]
                       AND [Temp].[StartDateTime]
                       BETWEEN [Discarded].[StartDateTime] AND [Discarded].[EndDateTime]
                       AND [Temp].[PatientID] = [Discarded].[PatientID]
        WHERE
            [Discarded].[PatientChannelID] IS NULL
        ORDER BY
            [paramDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get processed list of statistics for the specified patient.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetProcessedStatisticsList';

