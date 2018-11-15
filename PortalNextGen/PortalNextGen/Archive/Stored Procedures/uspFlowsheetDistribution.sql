CREATE PROCEDURE [Archive].[uspFlowsheetDistribution]
    (
        @PatientID   INT,
        @FlowsheetID INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ir].[ObservationStartDateTime],
            COUNT(*) AS [CNT]
        FROM
            [Archive].[FlowsheetDetail] AS [ifd]
            INNER JOIN
                [Intesys].[Result]      AS [ir]
                    ON [ifd].[TestCodeID] = [ir].[TestCodeID]
        WHERE
            [ifd].[FlowsheetID] = @FlowsheetID
            AND (
                    [ir].[IsHistory] = 0
                    OR [ir].[IsHistory] IS NULL
                )
            AND [ir].[PatientID] = @PatientID
        GROUP BY
            [ir].[ObservationStartDateTime]
        ORDER BY
            [ir].[ObservationStartDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspFlowsheetDistribution';

