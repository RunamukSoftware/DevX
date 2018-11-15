CREATE PROCEDURE [Archive].[uspFlowsheetResults]
    (
        @PatientID       INT,
        @MinimuDateTime  DATETIME2(7),
        @MinimumDateTime DATETIME2(7),
        @FlowsheetID     INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            --[name],
            [ir].[TestCodeID],
            [ir].[ObservationStartDateTime],
            [ir].[ResultValue],
            [ir].[ResultID],
            [ir].[HasHistory],
            [ir].[OrderID],
            [ifd].[FlowsheetDetailID],
            [ir].[ModifiedUserID]
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
            AND [ir].[ObservationStartDateTime] >= @MinimuDateTime
            AND [ir].[ObservationStartDateTime] <= @MinimumDateTime;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspFlowsheetResults';

