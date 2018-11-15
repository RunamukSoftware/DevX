CREATE PROCEDURE [old].[uspIcsPrintServiceLoadPrintItems] (@NullBooleanTrue TINYINT)
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
            [PrintSwitch] = @NullBooleanTrue
        ORDER BY
            [JobNetDateTime],
            [PrintJobID],
            [PageNumber];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspIcsPrintServiceLoadPrintItems';

