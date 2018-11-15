CREATE PROCEDURE [Archive].[uspLoadFlowsheetDetail] (@FlowsheetID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ifd].[FlowsheetDetailID],
            [ifd].[FlowsheetID],
            [ifd].[Name],
            [ifd].[DetailType],
            [ifd].[ParentID],
            [ifd].[Sequence],
            [ifd].[TestCodeID],
            [ifd].[ShowOnlyWhenData],
            [ifd].[IsCompressed],
            [ifd].[IsVisible],
            [ifd].[FlowsheetEntryID],
            [ife].[FlowsheetEntryID],
            [ife].[TestCodeID],
            [ife].[DataType],
            [ife].[SelectListID],
            [ife].[Units],
            [ife].[NormalFloat],
            [ife].[AbsoluteFloatHigh],
            [ife].[AbsoluteFloatLow],
            [ife].[WarningFloatHigh],
            [ife].[WarningFloatLow],
            [ife].[CriticalFloatHigh],
            [ife].[CriticalFloatLow],
            [ife].[NormalInteger],
            [ife].[AbsoluteIntegerHigh],
            [ife].[AbsoluteIntegerLow],
            [ife].[WarningIntegerHigh],
            [ife].[WarningIntegerLow],
            [ife].[CriticalIntegerHigh],
            [ife].[CriticalIntegerLow],
            [ife].[NormalString],
            [ife].[MaximumLength],
            [imm].[Code],
            [imm].[ShortDescription]
        FROM
            [Archive].[FlowsheetDetail]       AS [ifd]
            LEFT OUTER JOIN
                [Archive].[FlowsheetEntry]    AS [ife]
                    ON [ifd].[FlowsheetEntryID] = [ife].[FlowsheetEntryID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode] AS [imm]
                    ON [ifd].[TestCodeID] = [imm].[CodeID]
        WHERE
            [ifd].[FlowsheetID] = @FlowsheetID
        ORDER BY
            [ifd].[ParentID],
            [ifd].[Sequence];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspLoadFlowsheetDetail';

