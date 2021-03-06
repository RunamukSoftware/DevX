﻿CREATE PROCEDURE [old].[uspGetLeadList]
    (
        @PatientID     INT,
        @TimeTagType   INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipt].[ParamDateTime],
            [ipt].[Value1],
            [ipt].[Value2]
        FROM
            [Intesys].[ParameterTimeTag]                         AS [ipt]
            LEFT OUTER JOIN
                [old].[vwDiscardedOverlappingLegacyWaveformData] AS [discarded]
                    ON [discarded].[PatientChannelID] = [ipt].[PatientChannelID]
                       AND [ipt].[ParamDateTime]
                       BETWEEN [discarded].[StartDateTime] AND [discarded].[EndDateTime]
                       AND [ipt].[PatientID] = [discarded].[PatientID]
        WHERE
            [ipt].[PatientID] = @PatientID
            AND [ipt].[TimeTagType] = @TimeTagType
            AND [ipt].[ParamDateTime] >= @StartDateTime
            AND [ipt].[ParamDateTime] <= @EndDateTime
            AND [discarded].[PatientChannelID] IS NULL
        ORDER BY
            [ipt].[ParamDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the list of leads for the specified patient.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLeadList';

