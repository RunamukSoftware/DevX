CREATE PROCEDURE [Archive].[uspNewestFlowsheetResultDateTime]
    (
        @PatientID   INT,
        @FlowsheetID INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MAX([ir].[ObservationStartDateTime]) AS [MaxDateTime]
        FROM
            [Archive].[FlowsheetDetail] AS [ifd]
            INNER JOIN
                [Intesys].[Result]      AS [ir]
                    ON [ifd].[TestCodeID] = [ifd].[TestCodeID]
        WHERE
            [ifd].[FlowsheetID] = @FlowsheetID
            AND (
                    [ir].[IsHistory] = 0
                    OR [ir].[IsHistory] IS NULL
                )
            AND [ir].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspNewestFlowsheetResultDateTime';

