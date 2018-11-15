CREATE PROCEDURE [ClinicalAccess].[uspGetProcStatList]
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
            CAST(224 AS SMALLINT) AS [SampleRate],
            [ipt].[PatientChannelID]
        FROM
            [Intesys].[ParameterTimeTag] AS [ipt]
        WHERE
            [ipt].[PatientID] = @PatientID
            AND [ipt].[TimeTagType] = @TimeTagType
            AND ([ipt].[ParamDateTime]
            BETWEEN @StartDateTime AND @EndDateTime
                )
        ORDER BY
            [ipt].[ParamDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetProcStatList';

