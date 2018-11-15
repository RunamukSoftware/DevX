CREATE PROCEDURE [ClinicalAccess].[uspGetPrintJobBitmapByJobIDAndPageNumber]
    (
        @PrintJobID INT,
        @PageNumber INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipj].[ByteHeight],
            [ipj].[BitmapHeight],
            [ipj].[BitmapWidth],
            [ipj].[PrintBitmap],
            [ipj].[RecordingTime]
        FROM
            [Intesys].[PrintJob] AS [ipj]
        WHERE
            [ipj].[PrintJobID] = @PrintJobID
            AND [ipj].[PageNumber] = @PageNumber;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetPrintJobBitmapByJobIDAndPageNumber';

