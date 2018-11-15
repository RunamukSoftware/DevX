CREATE PROCEDURE [old].[uspIcsPrintServiceGetActivePrintItem]
    (
        @FActivePrintJobID INT,
        @NullBooleanTrue   TINYINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [PrintJobID],
            [PageNumber],
            [EndOfJobSwitch]
        FROM
            [Intesys].[PrintJob]
        WHERE
            [PrintJobID] = @FActivePrintJobID
            AND [PrintSwitch] = @NullBooleanTrue
        ORDER BY
            [PageNumber];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspIcsPrintServiceGetActivePrintItem';

