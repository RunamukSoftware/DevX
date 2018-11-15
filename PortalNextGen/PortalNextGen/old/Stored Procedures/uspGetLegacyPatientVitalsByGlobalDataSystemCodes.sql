CREATE PROCEDURE [old].[uspGetLegacyPatientVitalsByGlobalDataSystemCodes]
    (
        @GlobalDataSystemCodes [old].[utpGlobalDataSystemCodeTable] READONLY,
        @PatientID             INT,
        @StartDateTime         DATETIME2(7),
        @EndDateTime           DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN
            SELECT
                [ALLVITAS].[RowNumber],
                [ALLVITAS].[GlobalDataSystemCode],
                [ALLVITAS].[VALUE],
                [ALLVITAS].[ResultTime],
                [ALLVITAS].[ResultFileTime],
                CAST(1 AS BIT) AS [IsResultLocalized]
            FROM
                (
                    SELECT
                        ROW_NUMBER() OVER (PARTITION BY
                                               [imc].[Code]
                                           ORDER BY
                                               [RESULT].[ResultDateTime] DESC
                                          )        AS [RowNumber],
                        [imc].[Code]               AS [GlobalDataSystemCode],
                        [RESULT].[ResultValue]     AS [Value],
                        CAST(NULL AS DATETIME2(7)) AS [ResultTime],
                        [RESULT].[ResultDateTime]  AS [ResultFileTime]
                    FROM
                        [Intesys].[Result]                AS [RESULT]
                        INNER JOIN
                            [Intesys].[MiscellaneousCode] AS [imc]
                                ON [imc].[CodeID] = [RESULT].[TestCodeID]
                        INNER JOIN
                            @GlobalDataSystemCodes        AS [gc]
                                ON [imc].[Code] = [gc].[GlobalDataSystemCode]
                    WHERE
                        [RESULT].[PatientID] = @PatientID
                        AND [RESULT].[ResultDateTime] >= @StartDateTime
                        AND [RESULT].[ResultDateTime] <= @EndDateTime
                        AND [RESULT].[ResultValue] IS NOT NULL
                ) AS [ALLVITAS]
            WHERE
                [ALLVITAS].[RowNumber] = 1;
        END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get legacy patient vitals by Global Data System (GDS) codes.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientVitalsByGlobalDataSystemCodes';

